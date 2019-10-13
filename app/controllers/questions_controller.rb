class QuestionsController < ApplicationController
  include Voted
  include UrlGenerator

  before_action :authenticate_user!, except: [:index, :show]

  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  after_action :publish_question, only: [:create]

  authorize_resource


  def index
    @questions = Question.all.order(created_at: :desc)
  end

  def show
    @answers = @question.answers.order(best: :desc, created_at: :desc)
    @answer = Answer.new(user: current_user)
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_achievement
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
      generate_urls(@question)
    else
      render :new
    end
  end

  def edit

  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted'
  end

  private

  def set_user
    if current_user.present?
      @user = current_user
    end
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      question: @question
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
    gon.current_question = @question
  end

  def question_params
    params.require(:question).permit(:title, :body, achievement_attributes: [:name, :image], files: [], links_attributes: [:name, :url, :_destroy])
  end

end

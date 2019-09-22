class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :question_author?, only: [:update, :destroy]

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

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_author?
    unless current_user&.creator?(@question)
      redirect_to @question, alert: 'Not enough permissions'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, achievement_attributes: [:name, :image], files: [], links_attributes: [:name, :url, :_destroy])
  end

end

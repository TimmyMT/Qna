class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :is_creator?, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    # @answer = @question.answers.new
  end

  def new
    @question = current_user.questions.new
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
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def is_creator?
    unless @question.user_id == current_user.id
      redirect_to question_path(@question), alert: 'Not enough permissions'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

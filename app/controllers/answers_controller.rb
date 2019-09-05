class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:create, :new]
  before_action :answer_author?, only: [:edit, :update, :destroy]


  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Answer successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer_author?
    unless current_user.is_creator?(@answer.user_id)
      redirect_to question_path(@answer.question), alert: 'Not enough permissions'
    end
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

end

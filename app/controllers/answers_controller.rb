class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user&.creator?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end

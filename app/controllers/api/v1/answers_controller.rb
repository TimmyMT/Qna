class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: :create

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      head :created, location: api_v1_answer_url(@answer)
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer
    if @answer.update(answer_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy
    head :ok
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end

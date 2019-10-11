class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, each_serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      head :created, location: api_v1_question_url(@question)
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    head :ok
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

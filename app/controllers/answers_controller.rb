class AnswersController < ApplicationController
  include Voted
  include UrlGenerator

  before_action :authenticate_user!

  before_action :set_answer, only: [:update, :destroy, :select_best]

  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    generate_urls(@answer)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def select_best
    @answer.switch_best
  end

  def destroy
    @answer.destroy
  end

  private

  def publish_comment
    return if @answer.errors.any?
    answer_files_urls = @answer.files.map { |file| [file.filename.to_s, url_for(file)] }
    ActionCable.server.broadcast(
        "answers-of-question_#{@answer.question.id}",
        answer: @answer,
        answer_links: @answer.links,
        answer_files: answer_files_urls
    )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end

end

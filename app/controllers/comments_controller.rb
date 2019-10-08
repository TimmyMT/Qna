class CommentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save!
  end

  private

  def set_question_id(comment)
    if comment.commentable_type == 'Question'
      comment.commentable_id
    else
      comment.commentable.question.id
    end
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
        "comments-of-Question_#{set_question_id(@comment)}",
        comment: @comment
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

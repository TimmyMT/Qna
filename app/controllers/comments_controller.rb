class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save!
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
        'comments',
        comment: @comment
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

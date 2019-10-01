class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments"
  end
end

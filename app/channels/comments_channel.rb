class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "comments-of-Question_#{params['question_id']}"
  end
end

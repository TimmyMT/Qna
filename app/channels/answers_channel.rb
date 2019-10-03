class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "answers-of-question_#{params['question_id']}"
  end
end

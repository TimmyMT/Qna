class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |user|
      AnswerNotificationMailer.notify(user, answer).deliver_later
    end
  end
end

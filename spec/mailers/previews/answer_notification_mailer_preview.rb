class AnswerNotificationMailerPreview < ActionMailer::Preview
  def notify
    AnswerNotificationMailer.notify
  end
end

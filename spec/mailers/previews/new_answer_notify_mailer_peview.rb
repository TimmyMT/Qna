class NewAnswerNotifyMailerPreview < ActionMailer::Preview
  def notify
    NewAnswerNotifyMailer.notify
  end
end

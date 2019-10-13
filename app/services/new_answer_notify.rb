class Services::NewAnswerNotify
  def send_notify(answer)
    NewAnswerNotifyMailer.notify_email(answer).deliver_later
  end
end

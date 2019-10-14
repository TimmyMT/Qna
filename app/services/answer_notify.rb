class Services::AnswerNotify
  def send_daily_digest
    User.all.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end

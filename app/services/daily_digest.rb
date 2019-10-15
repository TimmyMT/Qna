class Services::DailyDigest
  def send_digest
    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end

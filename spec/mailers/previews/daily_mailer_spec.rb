class DailyMailerPreview < ActionMailer::Preview
  def digest
    DailyMailer.digest
  end
end

class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    @questions = Question.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)

    mail to: user.email
  end
end

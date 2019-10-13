class NewAnswerNotifyMailer < ApplicationMailer
  def notify_email(answer)
    @answer = answer
    @question = Question.find(@answer.question_id)
    @creator = User.find(@question.user_id)

    mail to: answer.question.user.email
  end
end

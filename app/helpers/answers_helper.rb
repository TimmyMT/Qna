module AnswersHelper
  def answer_present?(answer)
    Answer.find_by(id: answer.id).present?
  end
end

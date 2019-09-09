class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def switch_best
    if question.answers.exists?(best: true)
      previous_best = question.answers.find_by(best: true)
      previous_best.update!(best: false)
    end
    self.update!(best: true)
  end

end

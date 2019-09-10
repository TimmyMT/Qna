class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def switch_best
    question.answers.update_all(best: false)
    self.update(best: true)
  end

end

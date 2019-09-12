class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many_attached :files, dependent: :destroy

  validates :body, presence: true

  def switch_best
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

end

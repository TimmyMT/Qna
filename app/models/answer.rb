class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user
  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def switch_best
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

end

class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_one :rating, dependent: :destroy, as: :ratingable
  belongs_to :question
  belongs_to :user
  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :create_rating

  def create_rating
    self.build_rating
    self.save
  end

  def switch_best
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
      question.achievement.update!(user: self.user) if question.achievement.present?
    end
  end

end

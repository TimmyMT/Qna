class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  belongs_to :question
  belongs_to :user
  has_many_attached :files, dependent: :destroy
  has_many :url_files, dependent: :destroy, as: :url_fileable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_commit :subscriptions_notification

  def switch_best
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
      question.achievement.update!(user: self.user) if question.achievement.present?
    end
  end

  def subscriptions_notification
    AnswerNotificationJob.perform_later(self)
  end

end

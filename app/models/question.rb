class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user

  has_many :url_files, dependent: :destroy, as: :url_fileable
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_one :achievement, dependent: :nullify

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achievement, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_creator

  def subscribe_creator
    self.subscribers.push(self.user)
  end

  def subscribed?(user)
    self.subscriptions.where(user: user).present?
  end

end

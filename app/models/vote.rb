class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :user, uniqueness: true, if: :not_creator?

  def not_creator?
    return false if self.user.creator?(votable)
    !votable.votes.find_by(user: self.user).present?
  end

end

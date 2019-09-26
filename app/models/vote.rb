class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }

  # validates :validate_user_is_not_votable_author
  #
  # def validate_user_is_not_votable_author
  #   errors.add(:user, :cannot_be_votable_author) if user == votable.user
  # end

end

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
  validate :author_cant_vote, if: -> { user == votable.user }

  def author_cant_vote
    errors[:author] = 'Author cant vote'
  end

end

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validate :author_cant_vote

  def author_cant_vote
    errors[:user] << "Author can't vote" if user == votable.user
  end

end

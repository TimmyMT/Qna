class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :user, uniqueness: true, unless: :creator?

  def creator?
    votable.user == user
  end

end

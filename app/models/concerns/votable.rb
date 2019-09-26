module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create!(value: 1, user: user)
  end

  def vote_down(user)
    votes.create!(value: -1, user: user)
  end

  def vote_clear(user)
    votes.where(user: user).delete_all
  end

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.exists?(user: user)
  end
end

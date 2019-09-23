class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true

  serialize :votes, Hash

  def up(user)
    return if user.creator?(self.ratingable)

    unless self.votes.key?(user.id)
      transaction do
        self.votes[user.id] = '+'
        self.value += 1
      end
    end
  end

  def down(user)
    return if user.creator?(self.ratingable)

    unless self.votes.key?(user.id)
      transaction do
        self.votes[user.id] = '-'
        self.value -= 1
      end
    end
  end

  def clear_vote(user)
    return if user.creator?(self.ratingable)

    if self.votes.key?(user.id)
      transaction do
        self.value -= 1 if self.votes[user.id] == '+'
        self.value += 1 if self.votes[user.id] == '-'
        self.votes.delete(user.id)
      end
    end
  end

end

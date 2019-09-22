class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true

  serialize :votes, Hash

  def up(user)
    unless self.votes.key?(user.id) && !object_creator(user)
      transaction do
        self.votes[user.id] = '+'
        self.value += 1
      end
    end
  end

  def down(user)
    unless self.votes.key?(user.id) && !object_creator(user)
      transaction do
        self.votes[user.id] = '-'
        self.value -= 1
      end
    end
  end

  def clear_vote(user)
    if self.votes.key?(user.id) && !object_creator(user)
      transaction do
        self.value -= 1 if self.votes[user.id] == '+'
        self.value += 1 if self.votes[user.id] == '-'
        self.votes.delete(user.id)
      end
    end
  end

  private

  def object_creator(user)
    @object = self.ratingable_type.constantize.find(self.ratingable_id)
    user.creator?(@object)
  end
end

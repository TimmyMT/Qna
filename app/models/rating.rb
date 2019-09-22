class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true

  serialize :votes, Hash

  def up(user)
    unless object_creator(user)
      unless self.votes.key?(user.id)
        transaction do
          self.votes[user.id] = '+'
          self.value += 1
        end
      end
    end
  end

  def down(user)
    unless object_creator(user)
      unless self.votes.key?(user.id)
        transaction do
          self.votes[user.id] = '-'
          self.value -= 1
        end
      end
    end
  end

  def clear_vote(user)
    unless object_creator(user)
      if self.votes.key?(user.id)
        transaction do
          self.value -= 1 if self.votes[user.id] == '+'
          self.value += 1 if self.votes[user.id] == '-'
          self.votes.delete(user.id)
        end
      end
    end
  end

  private

  def object_creator(user)
    @object = self.ratingable
    user.creator?(@object)
  end
end

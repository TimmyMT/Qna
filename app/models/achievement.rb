class Achievement < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image, dependent: :destroy

  validates :question, presence: true

  def image_thumbnail
    self.image.variant(resize: '50x50')
  end

end

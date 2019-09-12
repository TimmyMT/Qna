class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many_attached :files, dependent: :destroy

  validates :title, :body, presence: true
end

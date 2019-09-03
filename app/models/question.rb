class Question < ApplicationRecord
  has_many :answers, dependent: :nullify
  belongs_to :user

  validates :title, :body, presence: true
end

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: :Answer, foreign_key: :best_answer_id

  validates :title, :body, presence: true
end

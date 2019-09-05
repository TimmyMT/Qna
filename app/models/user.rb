class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_creator?(user_id)
    self.id == user_id
  end

end

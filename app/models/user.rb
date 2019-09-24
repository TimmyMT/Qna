class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :achievements, dependent: :nullify
  has_many :votes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def creator?(object)
    self.id == object.user_id
  end

end

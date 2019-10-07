class User < ApplicationRecord
  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :achievements, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def creator?(object)
    self.id == object.user_id
  end

  def not_creator?(object)
    !creator?(object)
  end

  def create_authorization!(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

end

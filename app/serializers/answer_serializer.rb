class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :links, :comments, :url_files, :user_id

  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :links
  has_many :url_files

  def user_id
    Answer.find(object.id).user_id
  end
end

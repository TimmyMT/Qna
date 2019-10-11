class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :links, :comments, :url_files

  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :links
  has_many :url_files
end

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :links, :comments, :url_files

  belongs_to :user
  has_many :answers
  has_many :comments
  has_many :links
  has_many :url_files

  def short_title
    object.title.truncate(7)
  end
end

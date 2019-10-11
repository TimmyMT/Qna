class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end

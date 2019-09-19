class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp }

  def gist?
    host = URI.parse(url).host
    host&.include?('gist.github.com')
  end

  def gist_id
    return unless gist?
    url.split('/').reject!(&:empty?).last
  end

end

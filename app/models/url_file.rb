class UrlFile < ApplicationRecord
  belongs_to :url_fileable, polymorphic: true
end

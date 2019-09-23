module Ratingable
  extend ActiveSupport::Concern

  included do
    has_one :rating, dependent: :destroy, as: :ratingable

    after_create :create_rating!
  end
end

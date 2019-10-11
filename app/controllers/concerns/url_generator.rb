module UrlGenerator
  extend ActiveSupport::Concern

  def generate_urls(resource)
    if resource.files.attached?
      resource.files.each do |file|
        resource.url_files.create!(url: url_for(file))
      end
    end
  end
end

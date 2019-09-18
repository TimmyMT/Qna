FactoryBot.define do
  factory :achievement do
    name { "Achievement name" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/static/stewart.jpg") }
    association :question
  end
end

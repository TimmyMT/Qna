FactoryBot.define do
  factory :answer do
    body { "MyText" }
  end

  trait :invalid_answer do
    body { nil }
  end

  trait :with_attachment do
    after(:create) do |answer|
      file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")
      answer.files.attach(io: file, filename: 'rails_helper.rb')
    end
  end
end

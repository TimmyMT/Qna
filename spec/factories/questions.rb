FactoryBot.define do
  factory :question, aliases: [:linkable] do
    title { "MyString" }
    body { "MyText" }

    trait :invalid_question do
      title { nil }
    end

    trait :of_user do
      association :user, factory: :user
    end

    trait :with_attachment do
      after(:create) do |question|
        file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")
        question.files.attach(io: file, filename: 'rails_helper.rb')
      end
    end
  end
end

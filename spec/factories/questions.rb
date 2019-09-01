FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid_question do
      title { nil }
    end
  end
end

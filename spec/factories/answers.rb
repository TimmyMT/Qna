FactoryBot.define do
  factory :answer do
    body { "MyText" }
  end

  trait :invalid_answer do
    body { nil }
  end
end

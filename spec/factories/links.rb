FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "http://google.com" }

    trait :of_question do
      association :linkable, factory: :question
    end

    trait :of_answer do
      association :linkable, factory: :answer
    end
  end
end

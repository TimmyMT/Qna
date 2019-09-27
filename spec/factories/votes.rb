FactoryBot.define do
  factory :vote do

    value { 0 }

    trait :of_question do
      association :votable, factory: :question
    end

    trait :of_answer do
      association :votable, factory: :answer
    end
  end
end

FactoryBot.define do
  factory :question do
    title { "Question String" }
    body { "Question Text" }

    trait :invalid do
      title { nil }
    end
  end
end

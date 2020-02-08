FactoryBot.define do
  factory :comment do
    body { "Comment Text" }
    user

    trait :invalid do
      body { nil }
    end
  end
end

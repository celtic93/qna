FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }

    trait :invalid do
      url { "url" }
    end
  end
end

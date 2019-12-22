FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }
  end

  trait :invalid do
    url { "url" }
  end
end

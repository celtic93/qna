FactoryBot.define do
  factory :authorization do
    user
    provider { "MyString" }
    uid { "MyString" }

    trait :vkontakte do
      provider { "vkontakte" }
      uid { "123" }
    end
  end
end

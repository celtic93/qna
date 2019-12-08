include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { "Question String" }
    body { "Question Text" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end
  end
end

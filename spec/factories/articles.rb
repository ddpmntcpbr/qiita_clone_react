FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user
    status { "published" }

    trait :save_draft do
      status { "draft" }
    end
  end
end
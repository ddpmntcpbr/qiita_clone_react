FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    article
    user
  end
end

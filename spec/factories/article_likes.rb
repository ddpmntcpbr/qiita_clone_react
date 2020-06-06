FactoryBot.define do
  factory :article_like do
    association :user, factory: :user
    article
  end
end

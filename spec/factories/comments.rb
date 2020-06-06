FactoryBot.define do
  factory :comment do
    body { "MyString" }
    user { nil }
    article { nil }
  end
end

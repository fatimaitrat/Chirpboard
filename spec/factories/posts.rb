FactoryBot.define do
  factory :post do
    body { "This is a test post content" }

    association :user
  end
end
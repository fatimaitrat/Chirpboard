FactoryBot.define do
  factory :user do
    #Sequence ensure unique emails/usernames automatically

    sequence(:username) { |n| "user#{n}"}
    sequence(:email) { |n| "user#{n}@example.com"} 
    password { "password1223" }
  end
end
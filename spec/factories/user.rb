FactoryBot.define do
  factory :user do
    #Sequence ensure unique emails/usernames automatically

    sequence(:username) { |n| "user#{n}"}
    sequence(:email) { |n| "user#{n}@example.com"} 
    password { "password1223" }

    after(:build) do |user|
      def user.set_default_avatar
        return if avatar.attached?

        avatar.attach(
          io: File.open(Rails.root.join("spec","fixtures","files","default_avatar.svg")),
          filename: "default_avatar.svg",
          content_type: "image/svg+xml"
        )
      end
    end
  end
end
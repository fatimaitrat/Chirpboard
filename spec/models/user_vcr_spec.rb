require "rails_helper"

RSpec.describe User, type: :model do
  describe "avatar generation (with VCR)" do
    it "fetches a real avatar from DiceBear", :vcr do
      user = User.new(username: "vcr_test", email: "vcr@test.com", password: "password")

      user.save!
      expect(user.avatar).to be_attached
      expect(user.avatar.filename.to_s).to eq("avatar_vcr_test.svg")
    end
  end
end
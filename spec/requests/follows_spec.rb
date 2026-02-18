require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user, password: "password") }
  let(:other_user) { create(:user) }

  before do
    # Log in manually
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "POST /follows" do
    it "allows a user to follow another user" do
      expect {
        post follows_path,params: {followed_id: other_user.id}
      }.to change(Follow, :count).by(1)
      
      expect(response).to redirect_to(user_profile_path(other_user.username))
    end
  end

  describe "DELETE /follows/:id" do
    

    it "allows a user to unfollow" do
      follow =  Follow.create!(follower: user, followed: other_user)
      expect {
        delete follow_path(follow)
      }.to change(Follow, :count).by(-1)
      
      expect(response).to redirect_to(user_profile_path(other_user.username))
    end
  end
end
require 'rails_helper'
RSpec.describe "Api::V1::Follows", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) } 
  let(:valid_headers) { { "Authorization" => "Bearer #{user.auth_token}" } }
  describe "POST /api/v1/users/:id/follow" do

    context "when already following" do
      before { user.follow(other_user) }

      it "returns an error" do 
        post "/api/v1/users/#{other_user.id}/follow", headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("already following")
      end
    end
    context "when authenticated" do
      it "follows the user" do
        expect {
          post "/api/v1/users/#{other_user.id}/follow", headers: valid_headers
      }.to change(Follow, :count).by(1)
      end
    end

    context "when trying to follow self" do
      it "returns an error " do
        post "/api/v1/users/#{user.id}/follow", headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("You can not follow yourself")
      end
    end
  end

  describe "DELETE /api/v1/users/:id/unfollow" do

    context "when not following the user" do
      it "returns an error " do 
        delete "/api/v1/users/#{other_user.id}/unfollow", headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("not following")
      end
    end

    context "unfollowing the user" do
      before { user.follow(other_user) }

      it "unfollows the user" do
        expect {
          delete "/api/v1/users/#{other_user.id}/unfollow", headers: valid_headers
        }.to change(Follow, :count).by(-1)

        expect(response).to have_http_status(:ok)
        expect(user.following?(other_user)).to be false
      end
    end
  end
end
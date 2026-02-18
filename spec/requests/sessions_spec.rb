require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  let!(:user) { create(:user, username: "testuser", password: "password123") }

  describe "POST /api/v1/login" do
    context "with valid credentials" do
      it "returns a token and user data" do
        post "/api/v1/login", params: { username: "testuser", password: "password123" }, as: :json
        
        expect(response).to have_http_status(:ok)
        
        # JSON Parsing & Token Verification
        json = JSON.parse(response.body)
        expect(json["token"]).to eq(user.auth_token)
        expect(json["message"]).to eq("Login successful")
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/login", params: { session: { username: "testuser", password: "wrongpassword" } }, as: :json
        
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Invalid credential")
      end
    end
  end
  describe "DELETE /logout" do
    it "logs out the user" do
      # 1. Log in first
      post login_path, params: { email: user.email, password: "password" }
      
      # 2. Log out
      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
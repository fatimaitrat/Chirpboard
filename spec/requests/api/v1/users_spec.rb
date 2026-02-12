require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do

    context "with valid parameters" do
      it "creates a new user and returns a token" do
        user_params = {
          user: {
            username: "newbie",
            email: "new@test.com",
            password: "password123"
          }
        }

        expect {
          post "/api/v1/users", params: user_params, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
        expect(json["user"]["username"]).to eq("newbie")
      end
    end

    context "with invalid parameters" do 
      it "does not create a user if email is taken" do
        create(:user, email: "taken@test.com")

        bad_params = {
          user: {
            username: "copycat",
            email: "taken@test.com",
            password: "passsword123" 
          }
        }

        expect {
          post "/api/v1/users", params: bad_params, as: :json
        }.to_not change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Email has already been taken")
      end
    end
  end

end
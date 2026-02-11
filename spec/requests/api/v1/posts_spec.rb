require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  describe "GET /api/v1/posts" do
    let!(:user) { create(:user) }
    let!(:posts) { create_list(:post, 3, user:user)}

    #Helper to generate the Token header
    let(:valid_headers) { { "Authorization" => "Bearer #{user.auth_token}" } }

    describe "GET /api/v1/posts" do 
      context "when unauthenticated (Guest)" do
        it "returns 401 Unauthorized" do
          get "/api/v1/posts", as: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "when authenticated" do
        it "returns 200 OK and a list of posts" do
          get "/api/v1/posts", headers: valid_headers, as: :json

          expect(response).to have_http_status(:ok)

          #verify we actually got JSON back
          json_response = JSON.parse(response.body)
          expect(json_response["data"].size).to eq(3)
        end
      end
    end

    describe "POST /api/v1/posts" do
      context "with valid parameters" do
        it "creates a new post" do
          post_params = { post: { body: "This is a new API post"} } 
          expect {
            post "/api/v1/posts", params: post_params, headers: valid_headers, as: :json
          }.to change(Post, :count).by(1)
          expect(response).to have_http_status(:success)
          
        end
      end

      context "with invalid parameters" do 
        it "does not create a post" do
          invalid_params = { post: { body: "" } }

          expect{
            post "/api/v1/posts", params: invalid_params, headers: valid_headers, as: :json

        }.to_not change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /api/v1/posts/:id" do
      let!(:my_post) { create(:post, user: user) }
      let!(:other_post) { create(:post) } # Belongs to a different user

      context "when deleting own post" do
        it "deletes the post" do
          expect {
            delete "/api/v1/posts/#{my_post.id}", headers: valid_headers
          }.to change(Post, :count).by(-1)
          
          expect(response).to have_http_status(:ok)
        end
      end

      context "when trying to delete someone else's post" do
        it "returns 404 (Not Found) and does not delete" do
          expect {
            delete "/api/v1/posts/#{other_post.id}", headers: valid_headers
          }.to_not change(Post, :count)

          expect(response).to have_http_status(:not_found)
          # Optional: Check the error message
          json = JSON.parse(response.body)
          expect(json["error"]).to include("not found or permission denied")
        end
      end
    end
  end
end

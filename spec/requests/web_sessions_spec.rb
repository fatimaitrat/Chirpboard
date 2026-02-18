require 'rails_helper'
RSpec.describe "Web Sessions", type: :request do
  describe "POST /login" do 
    let(:user) { build_stubbed(:user, password: "password123") }

    it "logs the user in (using a Stub)" do
      allow(User).to receive(:find_by).with(email: user.email).and_return(user)

      allow(user).to receive(:authenticate).with("password123").and_return(true)

      post login_path, params: { email: user.email, password: "password123"}
      expect(response).to redirect_to(root_path)
    end
  end
end 
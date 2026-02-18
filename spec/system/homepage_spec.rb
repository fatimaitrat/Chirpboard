require 'rails_helper'

RSpec.describe "Homepage",  type: :system do
  describe "when user is a guest" do
    it "renders the welcome screen" do
      visit root_path

      #Check the main title(from your index.html.erb)
      expect(page).to have_content("Welcome to Chirpboard")

      #Check for the buttons 
      expect(page).to have_link("Log In")
      expect(page).to have_link("Sign Up")

      expect(page).to_not have_content("Hello,")  
    end
  end

  describe "when user is logged in" do
    let!(:user) { create(:user, name: "Hehehe", username: "he_he", password: "password123") }
    let!(:post) { create(:post, user: user, body: "Why are you laughing?") }

    before do
      sign_in_as(user)
    end

    it "shows the dashboard" do      
      expect(page).to have_content("Hello, Hehehe")

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Why are you laughing?")

      expect(page).to have_content("Delete Post")
    end

    context "interacting with posts" do
      it "allows user to create a new post" do
        click_link "+"

        expect(page).to have_content("New Post")
        fill_in "Body", with: "This is a brand new test post!"
        click_button "Post"

        expect(page).to have_content("Posted")
        expect(page).to have_content("This is a brand new test post!")

      end
    end
  end
end
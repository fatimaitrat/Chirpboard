require "rails_helper"

RSpec.describe "User Profile", type: :system do
  # 1. Create a user with a specific name so we can spot them
  let(:user) { create(:user, name: "Test User", password: "password") }

  it "allows user to upload an avatar" do
    # --- STEP 1: LOGIN ---
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log In"

    
    # We check for "Hello, Test User" because we know your dashboard has it!
    # This guarantees the session cookie is saved before we move on.
    expect(page).to have_content("Hello, Test User")

    # --- STEP 2: NAVIGATE ---
    visit edit_user_path(user)

    # Verify we are on the Edit Page
    expect(page).to have_content("Edit Profile")

    # --- STEP 3: UPLOAD ---
    # Use the robust finder to attach the file
    find("input[type='file']", visible: :all).attach_file(Rails.root.join("spec", "fixtures", "files", "default_avatar.svg"))

    click_button "Save Changes"

    # --- STEP 4: VERIFY ---
    expect(page).to have_content("Profile Updated")
  end
end
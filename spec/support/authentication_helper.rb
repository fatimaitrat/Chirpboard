module AuthenticationHelper
  def sign_in_as(user,password: "password123")
    visit login_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log In"
  end
end
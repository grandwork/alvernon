require 'test_helper'

class UserCanLogInTest < ActionDispatch::IntegrationTest
  test "User can log in" do
    user = Factory(:user)
    
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    
    click_on "Sign-in"
    
    assert page.has_content?("Signed in as #{user.email}")
    assert !page.has_content?("Invite user") 
  end
end

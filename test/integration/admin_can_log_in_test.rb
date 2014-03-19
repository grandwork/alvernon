require 'test_helper'

class AdminCanLogInTest < ActionDispatch::IntegrationTest
  test "Admin can log in" do
    admin = Factory(:admin)
    visit new_user_session_path
    assert page.has_selector?('form#user_new')
    fill_in "Email", :with => admin.email
    fill_in "Password", :with => "secret"
    click_on "Sign-in"
    assert page.has_content? ("Signed in as #{admin.email}")  
  end
end

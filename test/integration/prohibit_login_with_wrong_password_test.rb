require 'test_helper'

class ProhibitLoginWithWrongPasswordTest < ActionDispatch::IntegrationTest
  test "cannot log in with wrong password" do
    user = Factory(:admin)
    
    visit new_user_session_path
    fill_in "Email", :with => "johndoe@csindi.com"
    fill_in "Password", :with => "notsosecret"
    click_on "Sign-in"
    
    assert page.has_content? ("Wrong password or email.")
    assert_equal new_user_session_path, current_path  
  end
  
  test "cannot log in with wrong email" do
    user = Factory(:admin)
    
    visit new_user_session_path
    fill_in "Email", :with => "smarthaxx0r@somewhere.com"
    fill_in "Password", :with => "secret"
    click_on "Sign-in"
    
    assert page.has_content?("Wrong password or email.")
    assert_equal new_user_session_path, current_path
  end
end

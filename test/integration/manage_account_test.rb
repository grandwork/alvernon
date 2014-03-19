require 'test_helper'

class ManageAccountTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = Factory(:user)
    sign_in_as @user
  end
  
  def teardown
    User.delete_all
  end
  
  
  test "User can see a link to manage his account" do
    visit "/"
    
    assert page.has_link?("Account", :href => account_path ), "Should have a link to manage account"
  end
  
  test "User can change his first and last name" do
    visit account_path
    
    fill_in "First name", :with => "Harry"
    fill_in "Last name", :with => "Truman"
    click_on "Update account"
    
    assert_equal "Harry", @user.reload.first_name
    assert_equal "Truman", @user.reload.last_name  
  end
  
  test "User can change his password" do
    visit account_path
    
    click_on "Change password"
    
    fill_in "Current password", :with => 'secret'
    fill_in "New password", :with => "newpassword"
    fill_in "Confirm new password", :with => "newpassword"
    click_on "Change my password"
    
    assert_equal '/', current_path
    assert page.has_content?("Password updated")
    
    click_on "Sign-Out"
    
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => "newpassword"
    click_on "Sign-in"
    
    assert page.has_content?("Signed in successfully.")
  end
  
  test "User can't change his password without providing the old one" do
    visit account_path
    
    click_on "Change password"
    
    fill_in "Current password", :with => 'wrongpass'
    fill_in "New password", :with => "newpassword"
    fill_in "Confirm new password", :with => "newpassword"
    click_on "Change my password"
    
    assert page.has_content?("Current password is invalid")
  end
  
  test "User must provide identical passwords for confirmation" do
    visit account_path
    
    click_on "Change password"
    
    fill_in "Current password", :with => 'secret'
    fill_in "New password", :with => "newpassword"
    fill_in "Confirm new password", :with => "newpassword1"
    click_on "Change my password"
    
    assert page.has_content?("Password doesn't match confirmation")
  end
  
end

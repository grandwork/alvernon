require 'test_helper'

class AdminCanManageUsersTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = Factory(:admin)
    @user = Factory(:user)
    sign_in_as @admin
    visit admin_users_path
  end
  
  def teardown
    User.delete_all
    ActionMailer::Base.deliveries = []
  end

  test "Admin can see a list of users" do
    assert page.has_link?(@user.email), "Should list user email"
  end
  
  test "Admin can see pending invitations" do
    assert !page.has_content?("Pending invitations"), "Should not display anything if all invitations are accepted"
    
    visit new_user_invitation_path
    fill_in "user_email", :with => "some.one@csindi.com"
    click_on "Send Invitation"
    
    visit admin_users_path
    assert page.has_content?("Pending invitations"), "Should display pending invitations"
    assert page.has_content?("some.one@csindi.com"), "Should show email of the user"
    
  end
  
  test "Admin can resend invitations" do
    visit new_user_invitation_path
    fill_in "user_email", :with => "some.one@csindi.com"
    click_on "Send Invitation"
    
    visit admin_users_path
    assert_difference 'ActionMailer::Base.deliveries.length', 1, "Should resend invitation" do
      assert_no_difference 'User.count', "But not create new users" do
        click_on "Resend invitation"
      end
    end
  end
  
  test "Admin can cancel invitation" do
    visit new_user_invitation_path
    fill_in "user_email", :with => "some.one@csindi.com"
    click_on "Send Invitation"
    
    visit admin_users_path
      
    assert_difference 'User.count', -1, "Admin can cancel invitation" do
      click_on "Cancel invitation"
    end 

  end
  
  test "Admin can see other admins" do
    another_admin = Factory(:admin, :email => "another.admin@csindi.com")
    visit admin_users_path
    assert page.has_content?("Administrators: "), "Should have administrators header"
    assert page.has_link?(another_admin.email), "Should list another administrator"
  end
  
  test "Admin can promote to admin" do
    click_on "Promote to Admin"
    
    assert @user.reload.admin?, "should become admin"
  end
  
  test "user cannot access admin paths" do
    click_on "Sign-Out"

    sign_in_as @user
    
    visit admin_users_path
    assert_equal '/', current_path, "should be redirected to root"
    
    visit '/users/cancel_invitation/32'
    assert_equal '/', current_path, "should be redirected to root"
    
    visit '/users/resend_invitation/32'
    assert_equal '/', current_path, "should be redirected to root"
  end

end

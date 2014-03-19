require 'test_helper'

class UserInvitationTest < ActionDispatch::IntegrationTest
  
  def teardown
    User.delete_all
    ActionMailer::Base.deliveries = []
  end
  
  test "Admin can see Invitation link" do
    admin = Factory(:admin)
    sign_in_as admin
    
    assert page.has_link?("Invite User", :href => new_user_invitation_path)
  end
  
  test "User cannot see invitation link" do
    user = Factory(:user)
    sign_in_as user
    
    assert page.has_no_link?("Invite user", :href => new_user_invitation_path)
  end
  
  test "Admin can send invitations" do
    admin = Factory(:admin)
    sign_in_as admin
    visit new_user_invitation_path
    
    #assert_response :success
    assert page.has_button?("Send Invitation")
  end
  
  test "User cannot send invitations" do
    user = Factory(:user)
    sign_in_as user
    
    visit new_user_invitation_path
    
    assert_equal '/', current_path
  end
  
  test "Unauthorized request still redirects to sign in page" do
    visit new_user_invitation_path
    
    assert_equal new_user_session_path, current_path
  end
  
  
  # Ugly, but does its job
  test "An invitation is sent" do
    admin = Factory(:admin)
    sign_in_as admin
    
    # sending an invitation should create a user in the db with empty password
    assert_difference('User.count') do
      visit new_user_invitation_path
      fill_in "user_email", :with => "someone@csindi.com"
      click_on "Send Invitation"
    end
    
    # make sure the invited user has an invitation token
    token = User.last.invitation_token
    #ssert u.invitation_token
    
    assert page.has_content?("An invitation email has been sent to someone@csindi.com.")
    
    # make sure than an emain is delivered to the right person with right invitation_token
    assert !ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.first
    assert_equal ["someone@csindi.com"], email.to
    assert_match(/\/users\/invitation\/accept\?invitation_token=#{token}/, email.encoded)
    
    
    # make sure that resending invitation just sends the same token
    
    assert_no_difference('User.count') do
      visit new_user_invitation_path
      fill_in "user_email", :with => "someone@csindi.com"
      click_on "Send Invitation"
    end
    
    assert_equal token, User.last.invitation_token
  end
  
  test "Make sure an invited person cannot log in until he accepts the invitation" do
    admin = Factory(:admin)
    sign_in_as admin
    
    visit new_user_invitation_path
    fill_in "user_email", :with => "someone@csindi.com"
    click_on "Send Invitation"
    
    click_on "Sign-Out"
    
    fill_in "user_email", :with => "someone@csindi.com"
    click_on "Sign-in"
    
    assert page.has_content?("Wrong password or email.")
    
  end
  
  test "User can accept invitation" do
    admin = Factory(:admin)
    sign_in_as admin
    
    visit new_user_invitation_path
    fill_in "user_email", :with => "someone@csindi.com"
    click_on "Send Invitation"
    
    u = User.find_by_email('someone@csindi.com')
    
    click_on "Sign-Out"
    
    visit accept_user_invitation_path(:invitation_token => u.invitation_token)

    assert page.has_content?("Set your password"), "Page should have Set your password text"
    fill_in "Password", :with => "secret"
    fill_in "Password confirmation", :with => "secret"
    
    click_on "Set my password"
    
    assert page.has_content?("Your password was set successfully.")
    assert page.has_content?("Signed in as someone@csindi.com") 
  end
  
  test "Admin cannot invite a person outside CSI" do
    admin = Factory(:admin)
    sign_in_as admin
    
    assert_no_difference('User.count') do
      visit new_user_invitation_path
      fill_in "user_email", :with => "intruder@somewhere.com"
      click_on "Send Invitation"
    
      assert page.has_content?("Email must belong to someone from CSI")
    end
  end
  
  
  
end

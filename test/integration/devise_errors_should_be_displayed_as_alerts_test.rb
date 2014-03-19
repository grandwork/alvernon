require 'test_helper'

class DeviseErrorsShouldBeDisplayedAsAlertsTest < ActionDispatch::IntegrationTest
  test "Errors are shown in div.alert-message" do
    admin = Factory(:admin)
    sign_in_as admin
    
    visit new_user_invitation_path
    click_on "Send Invitation"
    
    assert page.has_selector?("div.alert"), "Page should display an alert"
    assert !page.has_selector?("div#error_explanation"), "Page should not display validation errors in the form"
  end
end

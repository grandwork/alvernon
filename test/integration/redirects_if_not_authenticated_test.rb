require 'test_helper'

class RedirectsIfNotAuthenticatedTest < ActionDispatch::IntegrationTest
  # fixtures :all

  test "redirects if not authenticated" do
    visit '/'
    assert_equal new_user_session_path, current_path
    assert !page.has_selector?("div.error")
  end
  
end

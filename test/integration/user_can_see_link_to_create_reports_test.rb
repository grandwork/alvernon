require 'test_helper'

class UserCanSeeLinkToCreateReportsTest < ActionDispatch::IntegrationTest
  test "User can see a link to create MPI report" do
    user = Factory(:user)
    sign_in_as user
    
    visit root_url
    assert page.has_link?("Magnetic Particle", :href => "/reports/mpi/new"), "There should be a link to create MPI report"
  end
end

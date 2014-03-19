require 'test_helper'

class SearchByClientTest < ActionDispatch::IntegrationTest

  def setup
    @user = Factory(:user)
    @reports = []
    2.times do |n|
      @reports[n] = Factory(:mpi)
      @reports[n].report.client = 'Client A'
      @reports[n].report.user = @user
      @reports[n].save!
    end
    
    @reports[2] = Factory(:mpi)
    @reports[2].report.client = 'Client B'
    @reports[2].report.user = @user
    @reports[2].save!
    
    sign_in_as @user
  end
  
  def teardown
    User.delete_all
    Report.delete_all
  end
  
  test "List of reports has links to quickly find all reports by a given client" do
    visit '/'

    assert page.has_link?('Client A'), "Should have a link to client"
  end
  
  test 'It finds the right reports' do
    visit '/'

    click_on "Client A"
    
    assert page.has_link?('Client A', :count => 2), "Should find 2 reports"
    assert !page.has_link?('Client B'), "Shouldn't have reports for Client B"
  end

end

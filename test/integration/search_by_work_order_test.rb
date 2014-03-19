require 'test_helper'

class SearchByWorkOrderTest < ActionDispatch::IntegrationTest

  def setup
    @user = Factory(:user)
    @reports = []
    2.times do |n|
      @reports[n] = Factory(:mpi)
      @reports[n].report.work_order_number = 'AB123'
      @reports[n].report.user = @user
      @reports[n].save!
    end
    
    @reports[2] = Factory(:mpi)
    @reports[2].report.work_order_number = 'CD456'
    @reports[2].report.user = @user
    @reports[2].save!
    
    sign_in_as @user
  end
  
  def teardown
    User.delete_all
    Report.delete_all
  end
  
  test "List of reports has links to quickly find all reports by work order #" do
    visit '/'

    assert page.has_link?('AB123'), "Should have a link to work order"
  end
  
  test 'It finds the right reports' do
    visit '/'
    
    click_on "AB123"
    
    assert page.has_link?('AB123', :count => 2), "Should find 2 reports"
    assert !page.has_link?('CD456'), "Shouldn't have reports for Client B"
  end

end

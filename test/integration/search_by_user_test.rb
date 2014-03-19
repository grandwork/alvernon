require 'test_helper'

class SearchByUserTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = Factory(:user)
    @user2 = Factory(:user, :email => "another.user@csindi.com")
    @admin = Factory(:admin)
     
    @reports = []
    2.times do |n|
      @reports[n] = Factory(:mpi)
      @reports[n].report.title = "Created by user"
      @reports[n].report.user = @user1
      @reports[n].save!
    end
    
    @reports[2] = Factory(:mpi)
    @reports[2].report.title = "Created by another user"
    @reports[2].report.user = @user2
    @reports[2].save!
    
   
    
    sign_in_as @admin
  end
  
  def teardown
    User.delete_all
    Report.delete_all
  end
  
  test "List of reports has links to quickly find all reports by a given user" do
    visit '/'

    assert page.has_link?(@user1.full_name), "Should have a link to user"
    assert page.has_link?(@user1.full_name), "Should have a link to user"
  end
  
  test 'It finds the right reports' do
    visit '/'
    
    click_on @user1.full_name
    
    assert page.has_link?('Created by user', :count => 2), "Should find 2 reports"
    assert !page.has_link?('Created by another user'), "Should not have reports created by another user"
  end

end


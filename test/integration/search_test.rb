require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  def setup
    @user = Factory(:user)
    @mpi = []
    @mpi << Factory(:mpi)
    @mpi[0].report.title = "Working specification"
    @mpi[0].report.user = @user
    @mpi[0].save
    
    sign_in_as @user
    
    @mpi << Factory(:mpi)
    @mpi[1].report.client = "ReSpec, Inc."
    @mpi[1].report.user = @user
    @mpi[1].save
    
    user = Factory(:user, :email => "rich.specci@csindi.com")
    @mpi << Factory(:mpi)
    @mpi[2].report.user = user
    @mpi[2].save
    
    @mpi << Factory(:mpi)
    @mpi[3].report.title = "Shouldn't find this title"
    @mpi[3].report.client = "ReSpec A/S"
    @mpi[3].report.work_order_number = "AB123"
    @mpi[3].report.user = @user
    @mpi[3].save
  end
  
  def teardown
    User.delete_all
    Mpi.delete_all
  end
  
  test 'Search finds results' do
    visit '/search?q=spec'
    
    # fill_in "q", :with => "spec"
    #     click_on "Search"
    
    assert page.has_content?("Search results for 'spec':"), "Should show the title"
    
    assert page.has_content?(@mpi[0].report.title), "Should find report by title"
    assert page.has_content?(@mpi[1].report.client), "Should find by client"
    assert page.has_content?(@mpi[2].report.user.full_name), "Should find by user"
    
    assert !page.has_content?(@mpi[3].report.title), "Should not find report without query"
  end
  
  test 'Search by work order number' do
    visit '/search?q=AB123'
    
    # fill_in "q", :with => "AB123"
    #     click_on "Search"
    
    assert page.has_content?("Shouldn't find this title"), "Should search by work order number"
  end
  
  test "Search clients without duplicates" do
    visit '/search?q=ReSpec'
    
    # fill_in "q", :with => "ReSpec"
    #     click_on "Search"
    
    #save_and_open_page
    assert page.has_css?("a", :text => "ReSpec A/S", :count => 1), "Should find exactly one client"
  end
  
  test "Search reports by uid" do
    visit "/search?q=#{@mpi[0].uid}"
    
    assert page.has_link?(@mpi[0].report.title), "Should find a report by uid"
  end

end

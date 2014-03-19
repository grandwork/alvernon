require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = Factory(:user)
    @admin = Factory(:admin)
    @mpi = Factory(:mpi)
    @mpi.report.user = @user
    @mpi.save
    
    sign_in_as @admin
  end
  
  def teardown
    User.delete_all
    Mpi.delete_all
  end
  
  test "Admin can see all reports" do
    visit root_url
    assert page.has_link?(@mpi.report.title, :href => reports_mpi_path(@mpi)), "Should have link to other users reports"
  end
  
  test "Admin can see 20 recent reports" do

    105.times do
      rep = Factory(:mpi)
      rep.report.user = @user
      rep.save
    end
    
    visit '/'
    
    within "#latest_reports" do
      assert page.has_css?('tr', :count => 20), "Should show 20 records"
    end
  end
  
  test "Admin should see 20 reports created by himself" do
    Report.delete_all
    
    25.times do
      rep = Factory(:mpi)
      rep.report.user = @admin
      rep.save
    end
    
    visit '/'
    
    #save_and_open_page
    within '#user_latest_reports' do
      assert page.has_css?('tr', :count => 20), "Should show 20 admin reports"
    end
  end
  
  test "Admin can see links to manage reports" do
    pending("So, there are now now quick links to edit report from the list?")
    visit root_url
    assert page.has_link?("Edit", :href => edit_reports_mpi_path(@mpi)), "Should have link to edit user report"
    assert page.has_link?("Delete", :href => reports_mpi_path(@mpi)), "Should have link to destroy user report"
  end
  
  test "Admin can edit all reports" do
    visit edit_reports_mpi_path(@mpi)
    
    fill_in "Title", :with => "Updated title"
    click_on "Update MPI report"
    
    assert_equal "Updated title", @mpi.reload.report.title 
  end
  
  test "Admin can delete any report" do
    assert_difference 'Report.count', -1 do
      visit reports_mpi_path(@mpi)
      click_on "Delete"
    end
  end
  
  test "User cannot edit other user's report" do
    user_2 = Factory(:user, :email => "other.email@csindi.com")
    
    click_on "Sign-Out"
    
    fill_in "Email", :with => user_2.email
    fill_in "Password", :with => "secret"
    
    click_on "Sign-in"
    
    visit reports_mpi_path @mpi
    assert !page.has_link?("Edit")
    
    visit edit_reports_mpi_path @mpi
    assert_equal '/', current_path 
  end
  
  test "User cannot delete other user's report" do
    user_2 = Factory(:user, :email => "other.email@csindi.com")
    
    click_on "Sign-Out"
    
    fill_in "Email", :with => user_2.email
    fill_in "Password", :with => "secret"
    
    click_on "Sign-in"
    
    visit reports_mpi_path @mpi
    assert !page.has_link?("Delete")
    
    assert_no_difference 'Report.count' do
      delete reports_mpi_path @mpi
    end

  end
  
  
  
end

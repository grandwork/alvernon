require 'test_helper'

class MpiReportsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = Factory(:user)
    sign_in_as @user
  end
  
  def teardown
    User.delete_all
    Mpi.delete_all
  end
  
  test "User can see create MPI report form" do
    visit new_reports_mpi_path
    assert page.has_content?("New MPI Report"), "should have title"
    assert page.has_field?("Procedure"), "should have procedure field"
    assert page.has_field?("Acceptance"), "should have acceptance field"
    assert page.has_field?("Date"), "should have date of inspection field"
    assert page.has_field?("Description"), "should have description field"
    assert page.has_field?("Client"), "should have client field"
    assert page.has_field?("Location"), "should have location field"
    assert page.has_field?("Drawing #"), "should have drawing number field"
    assert page.has_field?("Part #"), "should have part number field"
    assert page.has_field?("Title"), "should have title field"
    assert page.has_field?("Weld ID"), "should have weld number field"
    assert page.has_field?("Welder"), "should have welder field"
    assert page.has_field?("Material"), "should have meterial field"
    assert page.has_field?("Dimension"), "should have dimension field"
    assert page.has_field?("Thickness"), "should have thickness field"
    assert page.has_field?("Surface"), "should have surface condition field"
    assert page.has_field?("Welding process"), "should have welding process field"
    assert page.has_field?("Joint"), "should have joint type field"
    assert page.has_field?("Control extent"), "should have control extent field"
    assert page.has_field?("Equipment"), "should have equipment field"
    assert page.has_field?("Type of powder"), "should have type of powder field"
    assert page.has_field?("Current"), "should have current field"
    assert page.has_field?("Contrast"), "should have contrast field"
    assert page.has_field?("Field strength"), "should have field strength field"
    assert page.has_field?("Pole spacing"), "should have pole spacing field"
    
    assert page.has_button?("Create"), "should have create button"
    
  end
  
  test "User can create MPI report" do
    visit new_reports_mpi_path
    fill_in "Client", :with => "Keppel Norway AS"
    fill_in "Location", :with => "Dusavik"
    fill_in "Title", :with => "Welding procedure qualification, 2pcs"
    fill_in "Part", :with => "WPQ 164"
    fill_in "Drawing", :with => "N/A"
    fill_in "Date", :with => "01.12.2011"
    fill_in "Procedure", :with => "APP - QP - 07"
    fill_in "Acceptance", :with => "ISO 5817"
    fill_in "Weld", :with => "4-5"
    fill_in "Part #", :with => "WPQ 164"
    fill_in "Drawing #", :with => "N/A"
    fill_in "Date", :with => "01.12.2011"
    fill_in "Procedure", :with => "APP - QP - 07"
    fill_in "Acceptance", :with => "ISO 5817"
    fill_in "Weld ID", :with => "4-5"
    fill_in "Welder", :with => "KN03, KN07"
    fill_in "Material", :with => "C/S"
    fill_in "Dimension", :with => "88 mm"
    fill_in "Thickness", :with => "15 mm"
    fill_in "Surface", :with => "As welded"
    fill_in "Welding process", :with => "141"
    fill_in "Joint", :with => "Butt weld"
    fill_in "Control extent", :with => "100%"
    fill_in "Equipment", :with => "Yoke"
    fill_in "Type of powder", :with => "Black ink - wet"
    fill_in "Current", :with => "240 V - AC"
    fill_in "Contrast", :with => "White paint"
    fill_in "Field strength", :with => "4.5 kg min lift / 2.4-4.0 kA/m"
    fill_in "Pole spacing", :with => "75 - 200 mm"
    fill_in "Description", :with => "100% MPI carried out on the following welds:"
    
    assert_difference('Report.count', 1, "should create new report") do
      assert_difference('Mpi.count', 1, "should create mpi report") do
        click_on "Create" 
      end
    end
    
    r = Report.last
    assert_equal @user, r.user
                
  end
  
  test "User can view MPI report" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    
    visit reports_mpi_path(mpi)
    
    mpi.attributes.each_pair do |name, value|
      unless ["created_at", "updated_at"].include? name
        assert page.has_content?(value.to_s), "should display #{name} value"
      end
    end
    
    assert page.has_content?("01.12.2011"), "should display date in the right format"
    
    mpi.report.attributes.each_pair do |name, value|
      unless ["created_at", "updated_at", "specific", "specific_type", "date_of_inspection"].include? name
        assert page.has_content?(value.to_s), "should display #{name} value"
      end
    end
    
  end
  
  test "User can edit MPI report" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    
    visit reports_mpi_path(mpi)
    
    assert page.has_link?("Edit", :href => edit_reports_mpi_path(mpi)), "Page should have link to edit report"
    
    visit edit_reports_mpi_path(mpi)
    
    fill_in "Title", :with => "Updated title"
    click_on "Update MPI report"
    
    assert page.has_content?("was successfully updated."), "Page should display notice message"
    
    mpi = Mpi.find(mpi.id) # reload model to prevent caching
    
    assert_equal "Updated title", mpi.report.title, "Should update the record"  
    
  end
  
  test "User can delete MPI report" do  
    mpi = Factory(:mpi) 
    mpi.report.user = @user
    mpi.save
    
    visit reports_mpi_path(mpi)
    
    assert page.has_link?("Delete"), "should have link to delete the record"
    
    assert_difference("Mpi.count", -1, "should destroy mpi record") do
      assert_difference("Report.count", -1, "should destroy associated report") do
        click_on "Delete"
      end
    end
  end
  
  test "User can see his reports" do
    mpis = []
    3.times do
      r = Factory(:mpi)
      r.report.user = @user
      r.save
      mpis.push(r)
    end
    
    visit root_url
    mpis.each do |rep|
      assert page.has_link?(rep.report.title, :href => reports_mpi_path(rep)), "should have links to user reports"
    end
  end
  
  test "User can see technician name in the report" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    
    visit reports_mpi_path(mpi)
    
    assert page.has_content?("Technician"), "should have technician entry"
    assert page.has_content?(mpi.report.user.full_name), "should show the name of technician"
  end
  
  test "Reports have serial number" do
    visit new_reports_mpi_path
    assert page.has_content?("Serial #"), "should have serial number field"
    fill_in "Serial #", :with => "AN4942"
    click_on "Create MPI report"
    assert page.has_content? "AN4942" 
    
  end
  
  test "User can see signature image or default image" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    visit reports_mpi_path(mpi)
    assert page.has_selector?("#signature")
  end
  
  test "Report form should have trace number field" do
    visit new_reports_mpi_path
    assert page.has_field?("Trace number"), "should have trace number field"
  end
  
  test "User should be able to edit trace number" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    visit edit_reports_mpi_path(mpi)
    
    assert "12345" != mpi.report.trace_number, "shouldn't have value"
    
    #save_and_open_page
    
    fill_in "Trace number", :with => "12345"
    click_on "Update MPI report"
    
    assert "12345" == mpi.reload.report.trace_number, "should save to the db"
    
    visit reports_mpi_path(mpi)
    assert page.has_content?("12345"), "should display trace number on the report page"
  end
  
  test "MPI report should have UV, white light and batch number fields" do
    visit new_reports_mpi_path
    assert page.has_field?("UV light"), "should have UV light field"
    assert page.has_field?("White light"), "should have white light field"
    assert page.has_field?("Batch number"), "should have batch number field"
  end
  
  test "User should be able to edit UV, white and batch number fields" do
    mpi = Factory(:mpi)
    mpi.report.user = @user
    mpi.save
    visit edit_reports_mpi_path(mpi)
    
    assert "uv" != mpi.uv_light, "shouldn't have uv value"
    assert "white" != mpi.white_light, "shouldn't have white value"
    assert "batch" != mpi.batch_number, "shouldn't have batch number value"
    
    #save_and_open_page
    
    fill_in "UV light", :with => "uv"
    fill_in "White light", :with => "white"
    fill_in "Batch number", :with => "batch"
    click_on "Update MPI report"
    
    assert "uv" == mpi.reload.uv_light, "should save uv to the db"
    assert "white" == mpi.white_light, "should save white to the db"
    assert "batch" == mpi.batch_number, "should save batch number to the db"
    
    visit reports_mpi_path(mpi)
    assert page.has_content?("uv"), "should display uv on the report page"
    assert page.has_content?("white"), "should display white on the report page"
    assert page.has_content?("batch"), "should display batch on the report page"
  end
  
end

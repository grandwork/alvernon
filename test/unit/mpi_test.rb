require 'test_helper'

class MpiTest < ActiveSupport::TestCase
  test "Destroying an mpi record destroys associated report" do
    user = Factory(:user)
    mpi = Factory(:mpi)
    mpi.report.user = user
    mpi.save!
    
    assert_difference("Mpi.count", -1, "should destroy the MPI record") do
      assert_difference("Report.count", -1, "should also destroy Report record") do
        mpi.destroy
      end
    end
  end
  
  test "Has the right format of uid" do
    user = Factory(:user)
    mpi = Factory(:mpi)
    mpi.report.user = user
    mpi.save!
    
    assert_equal "MT-12-#{mpi.reload.id}", mpi.uid, "Should have uid like MT-12-43"
  end
  
  test "Sets default to N/A if blank field" do
    
    mpi = Mpi.new
    mpi.contrast = "white"
    mpi.save!
    
    mpi = Mpi.find(mpi.id)
    assert_equal 'N/A', mpi.equipment
    assert_equal 'white', mpi.contrast
  end
  
  test "Accepts nested attributes for defects" do
    mpi = Mpi.create
    
    assert_equal 0, mpi.mpi_defects.length, "New mpi has no defects"
        
    params = { :mpi => {
      :mpi_defects_attributes => [
        {:result => "Result 1" },
        {:result => "Result 2" }
      ]
    }}
        
    mpi = Mpi.create params[:mpi]
    
    assert_equal 2, mpi.mpi_defects.length, "Mpi must save defects"
        
    # params = { :mpi => {
    #       :mpi_defects_attributes => [
    #         {:result => "Result 1" },
    #         {:result => "Result 2" },
    #         {:result => ""}
    #       ]
    #     }}
    #     
    #     mpi = Mpi.create params[:mpi]
    #     
    #     assert_equal 2, mpi.mpi_defects.length, "Mpi mustn't save defects with empty image field set"  
        
    id = mpi.reload.mpi_defects.first.id
    
    params = { :mpi => {
      :mpi_defects_attributes => [
        { :id => id, :_destroy => true }
      ] 
    }}
    
    mpi.update_attributes params[:mpi]
    
    assert_equal 1, mpi.reload.mpi_defects.length, "Should destroy defect entry"
  end
  
  test "save_uid should store uid into associated report" do
    mpi = Mpi.create
    report = Report.create
    mpi.report = report
    mpi.save_uid
    assert mpi.uid == report.reload.uid, "Should store uid into report"
  end
end

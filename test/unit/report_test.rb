require 'test_helper'

class ReportTest < ActiveSupport::TestCase

    test "Report should have a title" do
      assert_raise(ActiveRecord::RecordInvalid) do
        report = create :report, :title => nil
      end
    end

    test "Report should have a client" do
      report = Report.new
      report.valid?
      assert_not_nil report.errors.get(:client)    
    end

    test "Sets date to current date before saved if date is nil" do
      report = create :report, :date => nil
  
      report = Report.find(report.id)
      assert_equal Date.today, report.date, "date should be today"
    end



  
  test "Doesn't affect date if date is given" do
    report = Report.new
    report.date_of_inspection = '12.07.2011'
    report.save!
    
    report = Report.find(report.id)
    assert_equal '12.07.2011', report.date_of_inspection.strftime('%d.%m.%Y'), "date shouldn't be affected"
  end
  
  test "Sets default to N/A if blank field" do
    report = Report.new
    report.location = "Given"
    report.save!
    
    report = Report.find(report.id)
    assert_equal 'N/A', report.client
    assert_equal 'Given', report.location
  end
  
  test "Delegates uid method to associated specific report" do
    report = Report.create
    mpi = Mpi.create
    mpi.report = report
    mpi.save!
    
    assert mpi.uid == report.reload.uid, "should delegate #{mpi.uid} to associated specific report #{report.uid}"
    
  end

  test "Accepts nested attributes for image attachments" do
    report = Report.create
    
    assert_equal 0, report.attached_images.length, "New report has no images"
    
    params = { :report => {
      :attached_images_attributes => [
        {:image => "Image 1" },
        {:image => "Image 2" }
      ]
    }}
    
    report = Report.create params[:report]
    
    assert_equal 2, report.attached_images.length, "Report must save attached images"
    
    params = { :report => {
      :attached_images_attributes => [
        {:image => "Image 1" },
        {:image => "Image 2" },
        {:image => ""}
      ]
    }}
    
    report = Report.create params[:report]
    
    assert_equal 2, report.attached_images.length, "Report mustn't save images without image field set"
    
    id = report.reload.attached_images.first.id

    params = { :report => {
      :attached_images_attributes => [
        { :id => id, :_destroy => true }
      ] 
    }}
    
    report.update_attributes params[:report]
    
    assert_equal 1, report.reload.attached_images.length, "Should destroy attached image"   
  end
end

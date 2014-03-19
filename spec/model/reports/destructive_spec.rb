require "spec_helper"

describe Destructive do
  context "when the user creates 5 destructive reports on 2012" do
    before { Timecop.freeze Time.new.change(year: 2012, month: 1, day: 1) }

    before do
      5.times do
        r = Report.new
        dt = Destructive.new
        dt.report = r
        if not dt.save
          raise "Error creating the reports: "+dt.report.errors.full_messages.join(", ")
        end

        Timecop.freeze Time.now.advance(seconds: 1)
      end
    end

    it "starts with DT-12-5" do
      Report.first.uid.should == "DT-12-5"
    end

    it "ends with DT-12-1" do
      Report.last.uid.should == "DT-12-1"
    end

    context "when the user edits and saves a report" do
      let(:dt) { Destructive.first }
      let(:old_uid) { dt.report.uid }
      before do
        dt.project_title = "project 1"
        dt.save
      end

      it "uid should not change" do
        dt.report.uid.should == old_uid
      end
    end

    context "and then the user creates 5 more reports on 2013" do
      before { Timecop.freeze Time.new.change(year: 2013, month: 1, day: 1) }

      before do
        5.times do
          r = Report.new
          dt = Destructive.new
          dt.report = r
          if not dt.save
            raise "Error creating the reports: "+dt.report.errors.full_messages.join(", ")
          end

          Timecop.freeze Time.now.advance(seconds: 1)
        end
      end

      it "starts with DT-13-5" do
        Report.first.uid.should == "DT-13-5"
      end

      it "ends with DT-12-1" do
        Report.last.uid.should == "DT-12-1"
      end
    end
  end

  after(:each) { Timecop.return }
end
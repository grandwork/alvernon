require "spec_helper"

describe Ultrasonic do
  context "when the user creates 5 ultrasonic reports on 2012" do
    before { Timecop.freeze Time.new.change(year: 2012, month: 1, day: 1) }

    before do
      5.times do
        r = Report.new
        ut = Ultrasonic.new
        ut.report = r
        if not ut.save
          raise "Error creating the reports: "+ut.report.errors.full_messages.join(", ")
        end

        Timecop.freeze Time.now.advance(seconds: 1)
      end
    end

    it "starts with UT-12-5" do
      Report.first.uid.should == "UT-12-5"
    end

    it "ends with UT-12-1" do
      Report.last.uid.should == "UT-12-1"
    end

    context "when the user edits and saves a report" do
      let(:ut) { Ultrasonic.first }
      let(:old_uid) { ut.report.uid }
      before do
        ut.equipment = "equipment 1"
        ut.save
      end

      it "uid should not change" do
        ut.report.uid.should == old_uid
      end
    end

    context "and then the user creates 5 more reports on 2013" do
      before { Timecop.freeze Time.new.change(year: 2013, month: 1, day: 1) }

      before do
        5.times do
          r = Report.new
          ut = Ultrasonic.new
          ut.report = r
          if not ut.save
            raise "Error creating the reports: "+ut.report.errors.full_messages.join(", ")
          end

          Timecop.freeze Time.now.advance(seconds: 1)
        end
      end

      it "starts with UT-13-5" do
        Report.first.uid.should == "UT-13-5"
      end

      it "ends with UT-12-1" do
        Report.last.uid.should == "UT-12-1"
      end
    end
  end

  after(:each) { Timecop.return }
end
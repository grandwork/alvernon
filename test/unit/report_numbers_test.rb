require 'test_helper'

class ReportNumbersTest < ActiveSupport::TestCase

  test "starts report numbers from 0 for DT reports created after 10.01.2013" do
    dt = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        dt = Destructive.new
        dt.report = r
        dt.save
     end
    end

    assert_equal "DT-13-5", dt.report.uid

    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      dt = Destructive.new
      dt.report = r
      dt.save
    end

    assert_equal "DT-13-0", dt.report.uid

    r = Report.new
    dt = Destructive.new
    dt.report = r
    dt.save

    assert_equal "DT-13-1", dt.report.uid
  end

  test "starts report numbers from 0 for reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Et.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "ET-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Et.new
      specific.report = r
      specific.save
    end

    assert_equal "ET-13-0", specific.report.uid

    r = Report.new
    specific = Et.new
    specific.report = r
    specific.save

    assert_equal "ET-13-1", specific.report.uid
  end

  test "starts report numbers from 0 for GT reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Inspection.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "GT-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Inspection.new
      specific.report = r
      specific.save
    end

    assert_equal "GT-13-0", specific.report.uid

    r = Report.new
    specific = Inspection.new
    specific.report = r
    specific.save

    assert_equal "GT-13-1", specific.report.uid
  end

  test "starts report numbers from 0 for MT reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Mpi.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "MT-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Mpi.new
      specific.report = r
      specific.save
    end

    assert_equal "MT-13-0", specific.report.uid

    r = Report.new
    specific = Mpi.new
    specific.report = r
    specific.save

    assert_equal "MT-13-1", specific.report.uid
  end

  test "starts report numbers from 0 for PT reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Pt.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "PT-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Pt.new
      specific.report = r
      specific.save
    end

    assert_equal "PT-13-0", specific.report.uid

    r = Report.new
    specific = Pt.new
    specific.report = r
    specific.save

    assert_equal "PT-13-1", specific.report.uid
  end

  test "starts report numbers from 0 for RT reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Radiographic.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "RT-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Radiographic.new
      specific.report = r
      specific.save
    end

    assert_equal "RT-13-0", specific.report.uid

    r = Report.new
    specific = Radiographic.new
    specific.report = r
    specific.save

    assert_equal "RT-13-1", specific.report.uid
  end

  test "starts report numbers from 0 for UT reports created after 10.01.2013" do
    specific = nil

    Timecop.freeze(Time.local(2013, 1, 11, 8, 59, 59)) do
      5.times do
        r = Report.new
        specific = Ultrasonic.new
        specific.report = r
        specific.save
     end
    end

    assert_equal "UT-13-5", specific.report.uid


    Timecop.freeze(Time.local(2013, 1, 11, 9, 0, 0)) do
      r = Report.new
      specific = Ultrasonic.new
      specific.report = r
      specific.save
    end

    assert_equal "UT-13-0", specific.report.uid

    r = Report.new
    specific = Ultrasonic.new
    specific.report = r
    specific.save

    assert_equal "UT-13-1", specific.report.uid
  end

end
class Ultrasonic < AbstractReport

  has_one :report, as: :specific, dependent: :destroy
  has_many :ut_defects, dependent: :destroy
  has_many :ut_probes, dependent: :destroy

  attr_accessible	:equipment,
  :sensitivity,
  :couplant,
  :correction,
  :report_attributes,
  :ut_defects_attributes,
  :calibration_date,
  :ut_probes_attributes,
  :cable,
  :cal_block

  accepts_nested_attributes_for :report
  accepts_nested_attributes_for :ut_defects, allow_destroy: true
  accepts_nested_attributes_for :ut_probes, allow_destroy: true

  delegate :uid, to: :report

 # after_initialize do |report|
 #   report.calibration_date ||= Date.today
 # end

  after_save do |ut|
    ut.report.set_uid("UT") unless ut.report.nil?
    ut.drop_pdf_path
  end

  def reject?
    result = self.ut_defects.map(&:result).map(&:downcase).include?("reject")
  end

  def pathname
    "ultrasonics"
  end

  def title
    "Ultrasonic".upcase
  end

  def pdf_path
    self.report.pdf_path
  end

  def deep_dup
    ut = Ultrasonic.new
    ut = self.dup
    self.ut_defects.each do |defect|
      ut.ut_defects << defect.dup
    end
    self.ut_probes.each do |probe|
      ut.ut_probes << probe.dup
    end
    ut
  end
end

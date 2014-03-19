class Et < AbstractReport

  has_one :report, as: :specific, dependent: :destroy
  has_many :et_probes, dependent: :destroy
  has_many :et_defects, dependent: :destroy

  default_scope order("updated_at DESC")
  attr_accessible :equipment,
  :serial,
  :calibration_due,
  :coating,
  :calibration_block,
  :et_probes_attributes,
  :report_attributes,
  :et_defects_attributes

  accepts_nested_attributes_for :report
  accepts_nested_attributes_for :et_probes, allow_destroy: true
  accepts_nested_attributes_for :et_defects, allow_destroy: true

  delegate :uid, to: :report

  #after_initialize do |report|
  #  report.calibration_due ||= Date.today
  #end

  after_save do |et|
    et.report.set_uid("ET") unless et.report.nil?
    et.drop_pdf_path
  end

  def title
    "Eddy Current".upcase
  end

  def reject?
    self.et_defects.map(&:result).map(&:downcase).include?("reject")
  end

  def pdf_path
    self.report.pdf_path
  end

  def deep_dup
    et = Et.new
    et = self.dup
    self.et_defects.each do |defect|
      et.et_defects << defect.dup
    end
    self.et_probes.each do |probe|
      et.et_probes << probe.dup
    end
    et
  end

  def pathname
    "ets"
  end
end

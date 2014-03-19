class Pt < AbstractReport

  has_one :report, as: :specific, dependent: :destroy
  has_many :pt_defects, dependent: :destroy

  attr_accessible	:light,
  :uv_light,
  :penetration_time,
  :developer_time,
  :batch,
  :dye_product,
  :dev_product,
  :cleaner_product,
  :pre_clean,
  :report_attributes,
  :temperature,
  :pt_defects_attributes

  accepts_nested_attributes_for :report
  accepts_nested_attributes_for :pt_defects, allow_destroy: true

  delegate :uid, to: :report

  after_save do |pt|
    pt.report.set_uid("PT") unless pt.report.nil?
    pt.drop_pdf_path
  end

  def title
    "Liquid Penetrant".upcase
  end

  def pdf_path
    self.report.pdf_path
  end

  def reject?
    self.pt_defects.map(&:result).map(&:downcase).include?("reject")
  end

  def deep_dup
    pt = Pt.new
    pt = self.dup
    self.pt_defects.each do |defect|
      pt.pt_defects << defect.dup
    end
    pt
  end

  def pathname
    "pts"
  end
end

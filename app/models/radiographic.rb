class Radiographic < AbstractReport

  has_one :report, as: :specific, dependent: :destroy
  has_many :rt_defects, dependent: :destroy

  attr_accessible	:equipment,
  :film_type,
  :lead_thickness,
  :density,
  :sensitivity,
  :sfd_ffd,
  :technique,
  :source_size,
  :iqi_type,
  :iqi_position,
  :exposure_data,
  :gu,
  :report_attributes,
  :rt_defects_attributes

  accepts_nested_attributes_for :report
  accepts_nested_attributes_for :rt_defects, allow_destroy: true

  delegate :uid, to: :report

  after_save do |rt|
    rt.report.set_uid("RT") unless rt.report.nil?
    rt.drop_pdf_path
  end

  def title
    "Radiographic".upcase
  end

  def pdf_path
    self.report.pdf_path
  end

  def deep_dup
    rt = Radiographic.new
    rt = self.dup
    self.rt_defects.each do |defect|
      rt.rt_defects << defect.dup
    end
    rt
  end

  def reject?
    self.rt_defects.map(&:accept_reject).map(&:downcase).include?("reject")
  end

  def pathname
    "radiographics"
  end
end

class Mpi < AbstractReport
  has_one :report, :as => :specific, :dependent => :destroy
  has_many :mpi_defects, :dependent => :destroy
  
  default_scope order("created_at DESC")  
  
  attr_accessible :equipment,
                  :report_attributes,
                  :type_of_powder,
                  :current,
                  :contrast,
                  :field_strength,
                  :pole_spacing,
                  :mpi_defects_attributes,
                  :uv_light,
                  :white_light,
                  :batch_number
  
  accepts_nested_attributes_for :report
  
  accepts_nested_attributes_for :mpi_defects, :allow_destroy => true

  delegate :uid, to: :report
  
  after_save do |mpi|
    mpi.report.set_uid("MT") unless mpi.report.nil?
    mpi.drop_pdf_path
  end

  def pdf_path
    self.report.pdf_path
  end

  def title
    "Magnetic Particle".upcase
  end

  def deep_dup
    mpi = Mpi.new
    mpi = self.dup
    self.mpi_defects.each do |defect|
      mpi.mpi_defects << defect.dup
    end
    mpi
  end

  def pathname
    "mpis"
  end

  def reject?
    result = self.mpi_defects.map(&:result).map(&:downcase).include?("reject")
  end
end
class Visual < AbstractReport


	has_one :report, as: :specific, dependent: :destroy
	has_many :visual_lines, dependent: :destroy

	default_scope order("created_at DESC")  

	attr_accessible :report_attributes, :visual_lines_attributes, :report_type

	accepts_nested_attributes_for :report
	accepts_nested_attributes_for :visual_lines, allow_destroy: true

	delegate :uid, to: :report

  after_save do |visual|
		visual.report.set_uid("VT") unless visual.report.nil?
		visual.drop_pdf_path
	end


	def pathname
		"visuals"
	end

	def title
		"Visual".upcase
	end

	def reject?
		self.visual_defects.map(&:result).map(&:downcase).include?("reject")
	end

	def pdf_path
		self.report.pdf_path
	end

	def deep_dup
		visual = Visual.new
		visual = self.dup
		self.visual_lines.each do |line|
			visual.visual_lines << line.dup
		end
		visual
	end


end

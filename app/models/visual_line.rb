class VisualLine < ActiveRecord::Base
	belongs_to :visual
  default_scope order(:created_at)

  VISUAL_LINE_RESULTS = {
		1 => "Accept",
		2 => "Reject"
	}


	def self.results_array
    arr = []
    VISUAL_LINE_RESULTS.each_pair do |k, v|
      arr << [v, k]
    end
    arr
  end


end

class AbstractReport < ActiveRecord::Base
  self.abstract_class = true

  delegate :update_pdf_path, :drop_pdf_path, to: :report
  
  def self.lookup(field, query)
    if self.column_names.include?(field)
      self.unscoped.select("DISTINCT(#{field})").collect {|res| res[field]}
    else
      return []
    end
  end
  
  before_save do |report|
    report.attributes.each_pair do |name, value|
      unless ["created_at", "updated_at", "images", "specific", "specific_type", "pdf_path", "user_id", "id", "report_id"].include? name
        report[name] = "N/A" if value.blank?
      end
    end
  end
  
end
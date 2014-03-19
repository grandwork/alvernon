class EmailsCart
  def initialize
    @reports = []
  end

  def fetch_reports
    reports = []
    @reports.each do |r|
      report = Report.find(r)
      reports << report unless report.nil?
    end
    reports
  end

  def add_report(report)
    @reports << report.to_s
    @reports.uniq!
  end

  def remove_report(report)
    @reports.delete(report.to_s)
  end

  def reports_count
    @reports.length
  end

  def has?(report)
    @reports.include? report.to_s
  end

  def puts
    str = ''
    @reports.each do |id|
      str += "#{id}, "
    end
    str
  end

  def any?
    @reports.length > 0
  end
end
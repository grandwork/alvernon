class Qualification < ActiveRecord::Base
  attr_accessible :level, :name, :number
  belongs_to :user
  has_many :reports
  before_destroy :check_reports

  validates :name, presence: true

  private
  def check_reports
  	if reports.any?
  		raise StandardError, "Reports exist with this qualification."
  	end
  end

end

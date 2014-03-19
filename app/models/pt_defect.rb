class PtDefect < ActiveRecord::Base
  belongs_to :pt
  default_scope order(:created_at)
end

class RtDefect < ActiveRecord::Base
  belongs_to :radiographic
  default_scope order(:created_at)
end

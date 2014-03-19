class EtDefect < ActiveRecord::Base
  belongs_to :EtDefect
  default_scope order(:created_at)

  default_scope order("created_at ASC")
end

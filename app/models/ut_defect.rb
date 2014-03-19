class UtDefect < ActiveRecord::Base
  belongs_to :ultrasonic
  default_scope order(:created_at)
end

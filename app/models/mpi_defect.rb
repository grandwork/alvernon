class MpiDefect < ActiveRecord::Base
  belongs_to :mpi
  default_scope order(:created_at)
  
  default_scope order("created_at ASC")
end

class EtProbe < ActiveRecord::Base
  belongs_to :et
  default_scope order(:created_at)
end

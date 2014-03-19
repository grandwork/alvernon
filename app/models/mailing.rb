class Mailing < ActiveRecord::Base
	belongs_to :report
	belongs_to :user

	default_scope order('created_at DESC')
end

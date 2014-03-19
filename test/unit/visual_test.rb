require 'test_helper'

class VisualTest < ActiveSupport::TestCase
  
	test "a visual instance can be created" do
		visual = Visual.new
		assert visual.valid?
	end

end

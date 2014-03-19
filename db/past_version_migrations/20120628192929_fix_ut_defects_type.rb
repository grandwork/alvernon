class FixUtDefectsType < ActiveRecord::Migration
  def up
  	change_table :ut_defects do |table|
  		table.rename :type, :defect_type
  	end
  end

  def down
  	change_table :ut_defects do |table|
  		table.rename :defect_type, :type
  	end
  end
end

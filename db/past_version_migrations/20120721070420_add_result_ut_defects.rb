class AddResultUtDefects < ActiveRecord::Migration
  def up
  	add_column :ut_defects, :result, :string
  end

  def down
  	remove_column :ut_defects, :result
  end
end

class AddCalToUltrasonics < ActiveRecord::Migration
  def change
  	add_column :ultrasonics, :cal_block, :string
  end
end

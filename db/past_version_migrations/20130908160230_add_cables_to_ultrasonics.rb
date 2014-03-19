class AddCablesToUltrasonics < ActiveRecord::Migration
  def change
  	add_column :ultrasonics, :cable, :string
  end
end

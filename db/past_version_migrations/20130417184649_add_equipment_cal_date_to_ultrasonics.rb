class AddEquipmentCalDateToUltrasonics < ActiveRecord::Migration
  def change
  	add_column :ultrasonics, :calibration_date, :date
  end
end

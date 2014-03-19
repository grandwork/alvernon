class CreateEts < ActiveRecord::Migration
  def change
    create_table :ets do |t|
      t.string :equipment
      t.string :serial
      t.date :calibration_due
      t.string :coating
      t.string :calibration_block
      t.references :report

      t.timestamps
    end
  end
end

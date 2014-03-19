class CreateUltrasonics < ActiveRecord::Migration
  def change
    create_table :ultrasonics do |t|
      t.string :equipment
      t.string :sensitivity
      t.string :couplant
      t.integer :correction
      t.references :report

      t.timestamps
    end
  end
end

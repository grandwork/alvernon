class CreateUtDefects < ActiveRecord::Migration
  def change
    create_table :ut_defects do |t|
      t.string :defect_id
      t.string :position
      t.string :length
      t.string :depth
      t.string :height
      t.string :angle
      t.string :db
      t.string :type
      t.integer :ultrasonic_id

      t.timestamps
    end
  end
end

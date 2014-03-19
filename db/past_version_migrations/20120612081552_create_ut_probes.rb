class CreateUtProbes < ActiveRecord::Migration
  def change
    create_table :ut_probes do |t|
      t.integer :angle
      t.string :serial
      t.integer :frequency
      t.string :type
      t.integer :ref
      t.integer :ultrasonic_id

      t.timestamps
    end
  end
end

class CreatePts < ActiveRecord::Migration
  def change
    create_table :pts do |t|
      t.string :light
      t.string :uv_light
      t.string :penetration_time
      t.string :developer_time
      t.string :batch
      t.string :pre_clean
      t.references :report

      t.timestamps
    end
  end
end

class CreateGtDefects < ActiveRecord::Migration
  def change
    create_table :gt_defects do |t|
      t.string :defect_id
      t.string :start
      t.string :length
      t.string :defect_type
      t.string :result
      t.references :inspection

      t.timestamps
    end
  end
end

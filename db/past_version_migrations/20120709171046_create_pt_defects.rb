class CreatePtDefects < ActiveRecord::Migration
  def change
    create_table :pt_defects do |t|
      t.string :defect_id
      t.string :start
      t.string :length
      t.string :defect_type
      t.string :result
      t.references :pt

      t.timestamps
    end
  end
end

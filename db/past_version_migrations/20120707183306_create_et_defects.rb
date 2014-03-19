class CreateEtDefects < ActiveRecord::Migration
  def change
    create_table :et_defects do |t|
      t.references :et
      t.string :scope
      t.string :start
      t.string :length
      t.string :defect_type
      t.string :result

      t.timestamps
    end
  end
end

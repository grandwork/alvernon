class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :number
      t.string :name
      t.string :level
      t.references :user

      t.timestamps
    end
  end
end

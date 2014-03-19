class CreateRtDefects < ActiveRecord::Migration
  def change
    create_table :rt_defects do |t|
      t.string :part_number
      t.string :welder
      t.string :area
      t.string :films
      t.string :accept_reject
      t.string :defect_type
      t.string :length
      t.string :location
      t.references :radiographic

      t.timestamps
    end
  end
end

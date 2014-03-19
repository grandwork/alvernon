class CreateVisuals < ActiveRecord::Migration
  def change
    create_table :visuals do |t|
      #t.string :equipment
      t.references :report


      t.timestamps
    end
  end
end

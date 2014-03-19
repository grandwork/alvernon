class CreateMpis < ActiveRecord::Migration
  def change
    create_table :mpis do |t|
      t.string :equipment
      t.string :type_of_powder
      t.string :current
      t.string :contrast
      t.string :field_strength
      t.string :pole_spacing
      
      t.timestamps
    end
  end
end

class CreateRadiographics < ActiveRecord::Migration
  def change
    create_table :radiographics do |t|
      t.string :equipment
      t.string :film_type
      t.string :lead_thickness
      t.string :density
      t.string :sensitivity
      t.string :sfd_ffd
      t.string :technique
      t.string :source_size
      t.string :iqi_type
      t.string :iqi_position
      t.string :exposure_data

      t.timestamps
    end
  end
end

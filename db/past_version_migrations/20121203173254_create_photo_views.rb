class CreatePhotoViews < ActiveRecord::Migration
  def change
    create_table :photo_views do |t|
      t.string :part_tested
      t.string :location
      t.string :position
      t.string :magnification
      t.string :photo
      t.references :destructive

      t.timestamps
    end
  end
end

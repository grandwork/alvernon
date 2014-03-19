class RemoveAttachedImagesTable < ActiveRecord::Migration
  def up
  	drop_table :attached_images
  end

  def down
  	create_table :attached_images do |t|
      t.references :report
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end

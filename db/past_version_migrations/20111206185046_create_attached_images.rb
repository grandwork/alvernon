class CreateAttachedImages < ActiveRecord::Migration
  def change
    create_table :attached_images do |t|
      t.references :report
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end

class CreateEditableImages < ActiveRecord::Migration
  def change
    create_table :editable_images do |t|
      t.string :image

      t.timestamps
    end
  end
end

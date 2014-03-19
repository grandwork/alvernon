class AddImagesToPhotoViews < ActiveRecord::Migration
  def change
    add_column :photo_views, :images, :string
  end
end

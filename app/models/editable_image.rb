class EditableImage < ActiveRecord::Base
  mount_uploader :image, EditableImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :crop

  def crop
    image.recreate_versions! if crop_x.present?
  end
end

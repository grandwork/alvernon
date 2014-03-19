class ImageAttachment < ActiveRecord::Base
  mount_uploader :image, ImageAttachmentUploader
end

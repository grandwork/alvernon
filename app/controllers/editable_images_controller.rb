class EditableImagesController < ApplicationController
  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @image = EditableImage.create(params[:editable_image])
    respond_to do |format|
      format.js
    end
  end

  def update
    @image = EditableImage.find(params[:id])
    @image.update_attributes(params[:editable_image])
  end
end
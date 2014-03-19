class TinymceAssetsController < ApplicationController
  def create
    attachment = ImageAttachment.new
    attachment.image = params[:file]
    attachment.save

    render json: {
      image: {
        url: request.protocol.to_s + request.host_with_port.to_s + attachment.image.url.to_s
      }
    }, content_type: "text/html"
  end
end

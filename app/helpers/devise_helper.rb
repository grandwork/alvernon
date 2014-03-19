module DeviseHelper

  def devise_error_messages!
     errors_as_alerts(resource)    
  end
end
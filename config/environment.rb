# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Alvernon::Application.initialize!

# Add pdf to supported MIME types
# Mime::Type.register "application/pdf", :pdf

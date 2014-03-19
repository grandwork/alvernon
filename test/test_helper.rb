ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'timecop'

class ActiveSupport::TestCase
	include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  #include Devise::TestHelpers
  private
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    click_on "Sign-in"
  end
end

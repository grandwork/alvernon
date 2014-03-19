class ClientTokensController < ApplicationController
	before_filter :authenticate_admin

	def new
		@email = params[:email]
		@sender = current_user
		@text = render_to_string "report_mailer/invite_client", format: :text
		respond_to do |format|
			format.js
		end
	end

	def create
		email = params[:email]
		user = User.find_or_create_by_email(email.downcase)
		user.ensure_authentication_token!
		token = user.authentication_token
		@link = "#{root_url}users/sign_in?auth_token=#{token}"
		ReportMailer.invite_client(email, current_user, @link).deliver
		redirect_to request.referer, notice: "Granted access to #{email}."
	end

	def destroy
		email = params[:email]
		user = User.find_by_email(email.downcase)
		user.authentication_token = nil
		user.save!
		redirect_to request.referer, notice: "Access for #{email} has been revoked."
	end

private
	def authenticate_admin
		redirect_to root_url unless current_user && current_user.admin?
	end
end
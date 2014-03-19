class ClientsController < ApplicationController
	layout "default"

	before_filter :authenticate_admin, except: [:list, :emails, :suggestions, :show]
  after_filter :clean_up_orphan_clients, :only => [:update, :destroy]


	def index
		@unapproved = Client.where('approved = ?', false)
		@approved = Client.where('approved = ?', true).page(params[:page])
	end

	def new
		@client = Client.new
	end

	def create
		@client = Client.create(params[:client])
		@client.approved = true

		if @client.save
			flash[:notice] = "Client has been added."
			redirect_to @client
		else
			render 'new'
		end
	end

	def show
		@client = Client.find(params[:id])
		redirect_to root_url unless current_user && (current_user.admin? or current_user.client == @client)
		#@reports = @client.reports.delete_if { |r| r.specific_type == "Destructive" and r.specific.approved_at.nil? }
		#@reports = Kaminari.paginate_array(@reports).page(params[:page])
	end

	def edit
		@client = Client.find(params[:id])
	end

	def update
		@client = Client.find(params[:id])
		# if user removes all emails, it wont be in params, we need to force it
		#@client.emails = params[:emails]

		if @client.update_attributes(params[:client])
			flash[:notice] = "Client has been updated."
			redirect_to @client
		else
			render 'edit'
		end
	end

	def destroy
		client = Client.find(params[:id])

		client.destroy
		flash[:notice] = 'Client was removed.'
		redirect_to clients_path
	end

	def approve
		client = Client.find(params[:id])
		client.approved = true
		client.save
		flash[:notice] = "#{client.name} has been approved."
		redirect_to clients_path
	end

	def list
		render json: Client.clients_list(params[:query])
	end

	def emails
		client = Client.find(params[:id])
		if params[:query].blank?
			render json: client.emails
		else
			render json: client.emails.grep(/#{params[:query]}/)
		end
	end

	def merge
		@source = Client.find(params[:source])
		@target = Client.find(params[:target])
		respond_to do |format|
			format.js
			format.html do
				@source.reports.each do |report|
					report.customer = @target
					report.client = @target.name
					report.save
				end
				@source.emails.each do |email|
					@target.emails << email
				end
				@target.save
				@source.destroy
				redirect_to clients_path, notice: "#{@source.name} was merged with #{@target.name}."
			end
		end
	end

	def suggestions
		q = params[:query]
		client = Client.where('name = ? ', q).first()
		if client
			data = true
		else
			clients = Client.suggestions_for(q)
			clients.any? ? data = clients : data = false
		end
		render json: data
	end

private
	def authenticate_admin
		redirect_to root_url unless current_user && current_user.admin?
	end

	def clean_up_orphan_clients
    User.delete_orphan_clients!
  end  
end
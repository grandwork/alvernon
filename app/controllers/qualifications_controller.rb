class QualificationsController < ApplicationController
  layout 'default'
  
	def index
		@qualifications = current_user.qualifications
	end

  def new
    @qualification = Qualification.new
  end

  def create
  	@qualification = current_user.qualifications.build params[:qualification]
    #qualification = Qualification.new(params[:qualification])
 		#qualification.user_id = current_user.id if current_user
    respond_to do |format|
      if @qualification.save
        format.html { redirect_to qualifications_path, notice: 'Qualification was successfully created.' }
        format.json { render json: @qualification, status: :created, location: @qualification }
      else
        format.html { render action: "new" }
        format.json { render json: @qualification.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  	@qualification = Qualification.find(params[:id])
  	#@qualification = current_user.qualification
  end

  def update
  	@qualification = Qualification.find(params[:id])
    respond_to do |format|
      if @qualification.update_attributes(params[:qualification])
        format.html { redirect_to qualifications_path, notice: 'Qualification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @qualification.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @qualification = Qualification.find(params[:id])
    begin
      @qualification.destroy
    rescue StandardError => message
      flash[:notice] = message.to_s
    end

    respond_to do |format|
      format.html { redirect_to qualifications_url }
      format.json { head :no_content }
    end
  end
end

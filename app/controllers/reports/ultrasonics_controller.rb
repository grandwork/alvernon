require 'open-uri'

class Reports::UltrasonicsController < ApplicationController  
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]
  
  def new
    @ut = Ultrasonic.new
    report = Report.find(params[:from]) if params[:from]
    if report
      @ut = Report.deep_dup(report, @ut)
    else
      @ut.report = Report.new
    end
  end
  
  def create
    @ut = Ultrasonic.new(params[:ultrasonic])
    @ut.report.user = current_user
   
    if @ut.save
      flash[:notice] = 'UT Report was successfully saved.'
      redirect_to reports_ultrasonic_path(@ut)
    else
      render :action => "new"
    end
  end
  
  def show
    @specific = Ultrasonic.find(params[:id])
    return redirect_to current_user.client if doesnt_belong_to_client(@specific)
    @object = @specific
    
    @can_manage = can_manage? @specific
    
    respond_to do |format|
      format.html
      format.pdf do
        send_data pdf_for(@specific), filename: "#{@specific.uid}.pdf", disposition: 'inline', type: 'application/pdf'
      end
    end
  end
  
  def edit    
    @ut = Ultrasonic.find(params[:id])
    
    unless can_manage? @ut
      redirect_to root_url
    end
  end
  
  def update
    @ut = Ultrasonic.find(params[:id])
    unless can_manage? @ut
      redirect_to root_url
    end
    
    if @ut.update_attributes(params[:ultrasonic])
      flash[:notice] = 'Ultrasonic Report was successfully updated.'
      redirect_to reports_ultrasonic_path(@ut)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    ut = Ultrasonic.find(params[:id])
    
    unless can_manage? ut
      redirect_to root_url
    end
    
    ut.destroy
    flash[:notice] = 'Ultrasonic Report was successfully deleted.'
    redirect_to root_url
  end
  
end

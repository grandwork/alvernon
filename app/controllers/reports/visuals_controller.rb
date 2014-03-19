require 'open-uri'

class Reports::VisualsController < ApplicationController  
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]
  
  def new
    @visual = Visual.new
    report = Report.find(params[:from]) if params[:from]

    if report
      @visual = Report.deep_dup(report, @visual)
    else
      @visual.report = Report.new
    end
  end
  
  def create
    @visual = Visual.new(params[:visual])
    @visual.report.user = current_user
   
    if @visual.save
      flash[:notice] = 'Visual report was successfully saved.'
      redirect_to reports_visual_path(@visual)
    else
      render :action => "new"
    end
  end
  
  def show
    @specific = Visual.find(params[:id])
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
    @visual = Visual.find(params[:id])
    
    unless can_manage? @visual
      redirect_to root_url
    end
  end
  
  def update
    @visual = Visual.find(params[:id])
    unless can_manage? @visual
      redirect_to root_url
    end
    
    if @visual.update_attributes(params[:visual])
      flash[:notice] = 'Visual report was successfully updated.'
      redirect_to reports_visual_path(@visual)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    visual = Visual.find(params[:id])
    
    unless can_manage? visual
      redirect_to root_url
    end
    
    visual.destroy
    flash[:notice] = 'Visual report was successfully deleted.'
    redirect_to root_url
  end
  
end

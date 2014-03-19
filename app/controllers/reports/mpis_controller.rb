require 'open-uri'

class Reports::MpisController < ApplicationController  
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]
  
  def new
    @mpi = Mpi.new
    report = Report.find(params[:from]) if params[:from]

    if report
      @mpi = Report.deep_dup(report, @mpi)
    else
      @mpi.report = Report.new
    end
  end
  
  def create
    @mpi = Mpi.new(params[:mpi])
    @mpi.report.user = current_user
   
    if @mpi.save
      flash[:notice] = 'MPI Report was successfully saved.'
      redirect_to reports_mpi_path(@mpi)
    else
      render :action => "new"
    end
  end
  
  def show
    @specific = Mpi.find(params[:id])
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
    @mpi = Mpi.find(params[:id])
    
    unless can_manage? @mpi
      redirect_to root_url
    end
  end
  
  def update
    @mpi = Mpi.find(params[:id])
    unless can_manage? @mpi
      redirect_to root_url
    end
    
    if @mpi.update_attributes(params[:mpi])
      flash[:notice] = 'MPI Report was successfully updated.'
      redirect_to reports_mpi_path(@mpi)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    mpi = Mpi.find(params[:id])
    
    unless can_manage? mpi
      redirect_to root_url
    end
    
    mpi.destroy
    flash[:notice] = 'MPI Report was successfully deleted.'
    redirect_to root_url
  end
  
end

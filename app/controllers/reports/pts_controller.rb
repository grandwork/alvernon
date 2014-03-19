require 'open-uri'

class Reports::PtsController < ApplicationController
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]

  def new
    @pt = Pt.new
    report = Report.find(params[:from]) if params[:from]
    if report
      @pt = Report.deep_dup(report, @pt)
    else
      @pt.report = Report.new
    end
  end

  def create
    @pt = Pt.new(params[:pt])
    @pt.report.user = current_user

    if @pt.save
      flash[:notice] = 'PT Report was successfully saved.'
      redirect_to reports_pt_path(@pt)
    else
      render :action => "new"
    end
  end

  def show
    @specific = Pt.find(params[:id])
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
    @pt = Pt.find(params[:id])

    unless can_manage? @pt
      redirect_to root_url
    end
  end

  def update
    @pt = Pt.find(params[:id])
    unless can_manage? @pt
      redirect_to root_url
    end

    if @pt.update_attributes(params[:pt])
      flash[:notice] = 'Liquid Penetrant Report was successfully updated.'
      redirect_to reports_pt_path(@pt)
    else
      render :action => "edit"
    end
  end

  def destroy
    pt = Pt.find(params[:id])

    unless can_manage? pt
      redirect_to root_url
      return
    end

    pt.destroy
    flash[:notice] = 'Radiographic Report was successfully deleted.'
    redirect_to root_url
  end
end

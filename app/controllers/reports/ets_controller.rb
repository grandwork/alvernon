class Reports::EtsController < ApplicationController
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]

  def new
    @et = Et.new
    report = Report.find(params[:from]) if params[:from]

    if report
      @et = Report.deep_dup(report, @et)
    else
      @et.report = Report.new
    end
  end

  def create
    @et = Et.new(params[:et])
    @et.report.user = current_user

    if @et.save
      flash[:notice] = "ET Report was successfully saved."
      redirect_to reports_et_path(@et)
    else
      render :action => "new"
    end
  end

  def show
    @specific = Et.find(params[:id])
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
    @et = Et.find(params[:id])

    unless can_manage? @et
      redirect_to root_url
    end
  end

  def update
    @et = Et.find(params[:id])
    unless can_manage? @et
      redirect_to root_url
    end

    if @et.update_attributes(params[:et])
      flash[:notice] = 'ET Report was successfully updated.'
      redirect_to reports_et_path(@et)
    else
      render :action => "edit"
    end
  end

  def destroy
    et = Et.find(params[:id])

    unless can_manage? et
      redirect_to root_url
    end

    et.destroy
    flash[:notice] = 'ET Report was successfully deleted.'
    redirect_to root_url
  end

end

require 'open-uri'

class Reports::RadiographicsController < ApplicationController
  layout "default"
  before_filter :proceed_if_admin, only: [:destroy]

  def flashes
    @rt = Radiographic.find(params[:id])
    respond_to do |format|
      format.js
      format.pdf do
        data = render_to_string :pdf => "Flashes for #{@rt.uid}",
                                :template => "/reports/radiographics/_flash.erb",
                                :wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
                                :layout => "pdf.html", 
                                :dpi => 300,
                                :page_size => 'A4',
                                :lowquality => false,
                                :show_as_html => params[:debug].present?, 
                                :margin => {  :top => 5,
                                              :bottom => 5,
                                              :left => 5,
                                              :right => 5 
                                            }
        send_data data, filename: "Flashes for #{@rt.uid}.pdf", disposition: 'inline', type: 'application/pdf'
      end
    end
  end

  def new
    @rt = Radiographic.new
    report = Report.find(params[:from]) if params[:from]
    if report
      @rt = Report.deep_dup(report, @rt)
    else
      @rt.report = Report.new
    end
  end

  def create
    @rt = Radiographic.new(params[:radiographic])
    @rt.report.user = current_user

    if @rt.save
      flash[:notice] = 'RT Report was successfully saved.'
      redirect_to reports_radiographic_path(@rt)
    else
      render :action => "new"
    end
  end

  def show
    @specific = Radiographic.find(params[:id])
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
    @rt = Radiographic.find(params[:id])

    unless can_manage? @rt
      redirect_to root_url
    end
  end

  def update
    @rt = Radiographic.find(params[:id])
    unless can_manage? @rt
      redirect_to root_url
    end

    if @rt.update_attributes(params[:radiographic])
      flash[:notice] = 'Radiographic Report was successfully updated.'
      redirect_to reports_radiographic_path(@rt)
    else
      render :action => "edit"
    end
  end

  def destroy
    rt = Radiographic.find(params[:id])

    unless can_manage? rt
      redirect_to root_url
    end

    rt.destroy
    flash[:notice] = 'Radiographic Report was successfully deleted.'
    redirect_to root_url
  end
end

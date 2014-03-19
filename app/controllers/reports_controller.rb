class ReportsController < ApplicationController
  layout "default"

  
  def search
    @q = params[:q]
    @field = params[:field] 
    case @field
    when 'client'
      @results = Report.for(@q).page(params[:page])
    when 'work_order'
      @results = Report.client_filter(current_user).with_work_order(@q).page(params[:page])
    when 'user'
      user = User.find(@q)
      @results = user.reports.page(params[:page])
    when 'all'
      @results = Report.page(params[:page])
    when 'ut_reports'
      @results = Report.where('specific_type = ?', 'Ultrasonic').page(params[:page])
    when 'mt_reports'
      @results = Report.where('specific_type = ?', 'Mpi').page(params[:page])
    when 'pt_reports'
      @results = Report.where('specific_type = ?', 'Pt').page(params[:page])
    when 'rt_reports'
      @results = Report.where('specific_type = ?', 'Radiographic').page(params[:page])
    when 'et_reports'
      @results = Report.where('specific_type = ?', 'Et').page(params[:page])
    when 'visual_reports'
      @results = Report.where('specific_type = ?', 'Visual').page(params[:page])
    when 'dt_reports'
      @results = Report.where('specific_type = ?', 'Destructive').page(params[:page])
    else
      redirect_to root_url
    end # checking :field 
  end
  
  def full_search
    @query = params[:q]
    if current_user.client.nil?
      @results = Report.search params
    else
      @results = Report.search_for_client params, current_user.client.title
    end
  end

  def send_multiple_via_email
    report_ids = params[:reports].split(',')
    emails = params[:emails]
    emails << ",#{current_user.email}" if params[:copy] == "true"
    message = params[:text]
    report_ids.each do |id|
      r = Report.find(id)
      @specific = r.specific
      @object = @specific
      pdf_for r.specific if @specific
      r.was_mailed! emails.gsub(',', ', '), current_user
    end
    ReportMailer.multiple_reports_email(emails, current_user, report_ids, message).deliver
    session[:emails_cart] = nil
    session[:new_emails] = params[:new_emails]
    session[:clients] = params[:clients]
    flash[:notice] = "#{params[:reports].split(',').length > 1 ? 'Reports have' : 'Report has'} been sent to #{params[:emails].gsub(',', ', ')}."
    render js: "window.location = '#{root_url}';"
  end
  
  def send_via_email
    unless /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.match params[:email]
      redirect_to :back, :alert => "You must provide a valid email address."
      return
    end
    
    report = Report.find(params[:id])
    sender = current_user

    known_emails = report.customer.emails
    unless known_emails.include?(params[:email])
      report.customer.emails << params[:email]
      report.customer.save
    end

    @specific = report.specific
    @object = @specific
    
    cc = ''
    cc = current_user.email if params[:cc]
    
    pdf = pdf_for report.specific

    ReportMailer.report_email(params[:email], sender, cc, report).deliver

    report.was_mailed! params[:email], current_user

    redirect_to :root, :notice => "Report has been sent to #{params[:email]}." 
  end

end
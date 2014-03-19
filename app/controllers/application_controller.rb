require 'open-uri'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Lock the gates
  before_filter :authenticate_user!
  #before_filter :deny_client_access, except: [:show, :full_search, :search, :destroy, :lookup]
  #before_filter :collect_statistics, except: [:lookup, :list]
  before_filter :set_emails_cart


protected

  def set_emails_cart
    if session[:emails_cart].nil?
      @emails_cart = EmailsCart.new
      session[:emails_cart] = @emails_cart
    else
      @emails_cart = session[:emails_cart]
    end
  end

  #def deny_client_access
  #  redirect_to current_user.client if current_user && current_user.client
  #end

  def doesnt_belong_to_client(report)
    current_user && current_user.client && current_user.client.title != report.report.client
  end

  def collect_statistics
    if Report.count > 0
      @stats = Statistics.first
      if @stats.nil?
        Statistics.collect_statistics
        @stats = Statistics.first
      end
      @total_number_of_user_reports = current_user.reports.count if current_user
    end 
  end

  # filter for devise_invitable
  def authenticate_inviter!
    unless current_user && current_user.admin?
      redirect_to root_url
    end
  end
  
  def can_manage?(specific_report)
    return false if current_user.client
    current_user.admin? or current_user == specific_report.report.user
  end
  
  def proceed_if_admin
    redirect_to root_url unless current_user.admin?
  end

  def proceed_if_super_admin
    redirect_to root_url unless current_user.super_admin?
  end

  def pdf_for(object)
    if object.pdf_path and File.exists?(object.pdf_path)
      pdf = File.open(object.pdf_path, 'rb').read
    else
      pdf = generate_pdf(object)
      save_path = Rails.root.join('public/reports', "#{object.uid}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      object.update_pdf_path(save_path.to_s)
      pdf
    end
  end

  def generate_pdf(object)
    type = object.pathname
    data = render_to_string :pdf => object.uid,
                            :template => "/reports/#{type}/show",
                            :formats => [:pdf],
                            :wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
                            :layout => "pdf.html", 
                            :dpi => 72,
                            :page_size => 'A4',
                            :show_as_html => params[:debug].present?, 
                            :margin => {  :top => 42,
                                          :bottom => 40,
                                          :left => 5,
                                          :right => 5 },
                            :header => {
                              :html => {
                                :template => "reports/#{type}/_header",
                                :formats => [:erb],
                                :layout => "pdf.html", 
                                :locals => {
                                  :object => object,
                                  :hide_page_js => false
                                }
                              }
                            },
                            :footer => {
                              :html => {
                                :template => "reports/#{type}/_footer",
                                :formats => [:erb],
                                :layout => "pdf.html", 
                                :locals => {
                                  :user => object.report.user,
                                  :report => object.report,
                                  :hide_page_js => false
                                }  
                              } 
                            }
  end

end
class EmailsController < ApplicationController
  def show
    @reports = @emails_cart.fetch_reports
    clients = @reports.map { |r| r.customer }
    emails = {}
    clients.uniq.each do |client|
      emails[client] = client.users.map { |u| u.email }
    end
    @emails = emails
  end

  def add_report
    @emails_cart.add_report(params[:id])
    session[:emails_cart] = @emails_cart
  end

  def remove_report
    @emails_cart.remove_report(params[:id])
    session[:emails_cart] = @emails_cart
  end

  def remove_report_from_editor
    @emails_cart.remove_report(params[:id])
    session[:emails_cart] = @emails_cart
  end

  def new_emails
    params[:data].each do |k, v|
      unless v["client"].blank?
        client = Client.where(title: v["client"]).first
        unless client.nil?
          client.emails << v["email"] unless client.emails.include? v["email"]
          client.save
        end
      end
    end
    session[:new_emails] = nil
    session[:clients] = nil
    render :js => "$('#new_emails').modal('hide');";
  end

  def clear_new_emails
    session[:new_emails] = nil
    session[:clients] = nil
    render :js => "$('#new_emails').modal('hide');";
  end
end
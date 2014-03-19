class HomeController < ApplicationController
  layout 'default'
  before_filter :proceed_if_admin, :except => [:index, :lookup, :account, :update_account, :remove_signature]
  before_filter :proceed_if_super_admin, :only => [:deleted_users, :undelete_user, :confirm_user_delete, :delete_user, :promote, :demote]
  before_filter :clean_up_orphan_clients, :only => [:users]
  before_filter :proceed_if_dt_admin, :only => [:receive_notifications, :dont_receive_notifications]
  
  def index
    if current_user.client
      redirect_to current_user.client
      return
    end
    logger.debug ("\n\n>>>>>>\n #{session[:new_emails]}\n\n#{session[:clients]}")
    unless session[:new_emails].nil?
      @new_emails = session[:new_emails]
      @clients = session[:clients]
    end
    @my_latest_reports = Report.latest_by(current_user)
    @latest_reports = Report.latest
    
  end

  def updates
    
  end

  def receive_notifications
    u = User.find(params[:id])
    u.update_attribute(:receive_dt_notification, true)
    redirect_to admin_admins_path
  end

  def dont_receive_notifications
    u = User.find(params[:id])
    u.update_attribute(:receive_dt_notification, false)
    redirect_to admin_admins_path
  end
  
  def users
    @deleted = User.where('deleted_at IS NOT NULL').count
    @pending = User.pending
    @admins = User.admins_without current_user
    @users = User.activated
    @employees = @users.select { |user| user.client.nil? }
    @clients = @users.select { |user| !user.client.nil? }
    @clients = Kaminari.paginate_array(@clients).page(params[:page])
  end

  def deleted_users
    @users = User.where('deleted_at IS NOT NULL').order('deleted_at DESC')
  end

  def undelete_user
    @user = User.find(params[:id])
    @user.deleted_at = nil if @user
    if @user && @user.save
      redirect_to admin_users_path, notice: "#{@user.full_name} was undeleted."
    else
      redirect_to deleted_users_path, alert: "Could not undelete #{@user.full_name}"
    end
  end

  def confirm_user_delete
    @user = User.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def delete_user
    @user = User.find params[:id]
    @user.deleted_at = Time.current
    @user.save!
    redirect_to admin_users_path, notice: "#{@user.full_name} has been deleted."
  end
  
  def promote
    if current_user.super_admin?
      user = User.find(params[:id]).promote
      redirect_to admin_admins_path, :notice => "#{user.full_name} has been promoted to admin"
    end 
  end 

  def demote
    if current_user.super_admin?
      user = User.find(params[:id]).demote
      redirect_to admin_technicians_path, notice: "#{user.full_name} has been demoted."
    end
  end
  
  def update_account
    if current_user.update_attributes(params[:user])
      redirect_to account_path, notice: 'Your account details were successfully updated.'
    else
      redirect_to account_path
    end 
  end
  
  def remove_signature
    current_user.remove_signature!
    current_user.save
    redirect_to account_path 
  end
  
  def resend_invitation
    user = User.find(params[:id])
    User.invite!(:email => user.email)
    redirect_to admin_pending_path, notice: "Invitation has been resent to #{user.email} ." 
  end
  
  def cancel_invitation
    user = User.find(params[:id])
    user.destroy if user.encrypted_password.blank?  
    redirect_to admin_pending_path, notice: "Invitation of #{user.email} has been cancelled" 
  end
  
  def lookup
    if request.xhr?                                       
      render :json => params[:model].capitalize.classify.constantize.lookup(params[:field], params[:query]).to_a
    else
      render :json => params[:model].capitalize.classify.constantize.lookup(params[:field], params[:query]).to_a
      #raise ActionController::RoutingError.new('Not Found')
    end
  end  

private
  def clean_up_orphan_clients
    User.delete_orphan_clients!
  end  

  def proceed_if_dt_admin
    redirect_to admin_users_path unless current_user.dt_super_admin?
  end
end

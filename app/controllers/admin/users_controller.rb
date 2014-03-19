class Admin::UsersController < ApplicationController
  layout 'default'
  before_filter :proceed_if_admin
  before_filter :proceed_if_super_admin, only: [:suspended, :suspend, :restore]
  before_filter :suspended_count
  before_filter :pending_count

  def technicians
    @users = User.activated
    @employees = @users.select { |user| user.client.nil? }
    @employees = Kaminari.paginate_array(@employees).page(params[:page])
  end

  def admins
    @admins = User.admins_without(current_user).page(params[:page])
  end

  def clients
    @users = User.activated
    @clients = @users.select { |user| !user.client.nil? }
    @clients = Kaminari.paginate_array(@clients).page(params[:page])
  end

  def pending
    @pending = User.pending.page(params[:page])
  end

  def suspended
    @employees = User.where('deleted_at IS NOT NULL').page(params[:page])
  end

  def restore
    user = User.find(params[:id])
    user.deleted_at = nil
    user.save
    redirect_to admin_suspended_path, notice: "Access for #{user.full_name} has been restored."
  end


  def suspend
    user = User.find(params[:id])
    user.deleted_at = Time.now
    user.save
    redirect_to :back, notice: "Access for #{user.full_name} has been suspended."
  end
private
  def suspended_count
    @suspended_count = User.where('deleted_at IS NOT NULL').count
  end

  def pending_count
    @pending_count = User.pending.count
  end
end
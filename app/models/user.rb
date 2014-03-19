class User < ActiveRecord::Base
  
  default_scope order("created_at DESC")
  
  scope :activated, where(:invitation_token => nil, :admin => false, :deleted_at => nil).order("email")
  scope :pending, where("invitation_token IS NOT NULL AND deleted_at IS NULL").order("invitation_sent_at DESC")
  scope :admins, where(:admin => true, :deleted_at => nil).order("email")
  scope :admins_without, lambda { |user| admins.where('id != ?', user.id) }
  
  # ==> Devise
  # Since there's no way to sign up except by being invited, we don't need "registrable"
  devise :invitable, :database_authenticatable, :token_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  
  belongs_to :client
  has_many :reports
  has_many :mailings
  has_many :qualifications, dependent: :destroy
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :signature, :signature_cache, :role, :client_id
  #attr_readonly :admin
  
  mount_uploader :signature, SignatureUploader
  
  def admin?
    true if admin    
  end

  def super_admin?
    true if super_admin
  end
  
  def full_name
    (first_name + ' ' + last_name).strip
  end

  def role
    if !client && !admin?
      "technician"
    elsif client
      "client"
    else
      ""     
    end 
  end

  def role=(role_param); end


  def qualifications_array
    qualifications.map do |q|
      [q.name, q.id]
    end 
  end
  
  def promote
    unless admin?
      self.admin = true
      save!
      self
    end
  end

  def demote
    self.admin = false
    save!
    self
  end

  def self.tech_count
    User.where(:invitation_token => nil, :admin => false, :deleted_at => nil).count
  end

  def self.admin_count
    User.where(super_admin: false, admin:true).count
  end

  def self.suspended_count
    User.where('deleted_at IS NOT NULL').count
  end

  def self.pending_count
    User.where('invitation_token IS NOT NULL AND deleted_at IS NULL').count
  end

  def self.most_active_users
    User.all.reject{|u| !u.client.nil? }.collect {|u| [u.reports.count, u.id, u.full_name] }.sort{ |a, b| a[0] <=> b[0]}.reverse[0...3]
  end

  def self.delete_orphan_clients!
    orphans = User.all.select{|u| u.client.nil? && !u.email.match(/csindi.com\z/)}
    orphans.each { |orphan| orphan.destroy }
  end
  
  def self.search_by_full_name(query)
    query = self.prepare_query query
    if query[1].nil?
      User.select('DISTINCT email, *').where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?', query[0], query[0])
    else
      User.select('DISTINCT email, *').where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?', query[0], query[0], query[1], query[1])
    end
  end

  def self.has_access?(email)
    user = User.find_by_email(email)
    return false if user.nil?
    user.authentication_token.blank? ? false : true
  end

  

  
  
  before_save do |user| 
    if user.first_name.blank? 
      name = user.email.split('@', 2)
      name = name[0].split('.', 2)   
      user.first_name ||= name[0].capitalize
      user.last_name ||= name[1].capitalize unless name[1].nil? 
    end
    user.last_name ||= ""
  end

  # used by Devise to determine if a user can log in
  #def active_for_authentication?
  #  return false if !email.match(/csindi.com\z/)
  #  super && !deleted_at
  #end
  
private
  def self.prepare_query(query)
    query = query.strip.squeeze(' ').downcase
    arr = query.split(' ')
    arr.map { |el| "%#{el}%"}
  end
end

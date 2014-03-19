class Report < AbstractReport

  include Tire::Model::Search
  include Tire::Model::Callbacks

  RESULTS = {
    0 => "Leave Blank",
    1 => "Acceptable to Specification",
    2 => "Not Acceptable to Specification"
  }

  belongs_to :user
  belongs_to :qualification
  belongs_to :customer, class_name: "Client"
  belongs_to :specific, :polymorphic => true, dependent: :destroy
  has_many :mailings, dependent: :destroy

  validates :uid, uniqueness: true, unless: -> { uid == "N/A" }
  validates :title, presence: true
  validates :client, presence: true

  scope :latest, order('updated_at desc').limit(20)
  scope :latest_by, lambda { |user| where(user_id: user.id).order('updated_at desc').limit(20) }
  scope :for, lambda { |client| where(client: client).order('updated_at DESC') }
  scope :with_work_order, lambda { |work_order| where(work_order_number: work_order).order('updated_at DESC') }
  scope :by_user, lambda { |user| where(user_id: user).order('updated_at DESC') }
  scope :client_filter, lambda { |user| where(client: user.client.title) unless user.client.blank? }

  default_scope order('updated_at DESC')
  
  # has_many :attached_images, :dependent => :destroy
  
  # accepts_nested_attributes_for :attached_images, :reject_if => lambda { |image| image[:image].blank? }, :allow_destroy => true 
  
  #delegate :uid, :to => :specific 
  
  attr_accessible :procedure,
                  :code,
                  :date,
                  :description,
                  :client,
                  :job_number,
                  :location,
                  :title,
                  :attached_images_attributes,
                  :result,
                  :qualification_id
                  

  
    
  

  def set_uid(type)
    # only set uid if not set already
    return if self.uid != nil and self.uid != "N/A"

    # get 13 from 2013
    year_str = Time.now.year.to_s[2, 2]
    # get reports of this type and year
    reports = Report.by_created_at.where("reports.uid like ? and uid not like ?", "#{type}-#{year_str}-%", "%*")

    if reports.empty?
      self.uid = "#{type}-#{Time.now.year.to_s[2, 2]}-1"
    else
      last_uid = reports.first.uid.split("-").last.to_i
      self.uid = "#{type}-#{Time.now.year.to_s[2, 2]}-#{last_uid+1}"
    end
  end

  def self.by_uid
    with_exclusive_scope { order('uid desc') }
  end

  def self.by_created_at
    with_exclusive_scope { order('created_at desc') }
  end

  def self.search(params)
    tire.search(load: true, page: params[:page], per_page: 20) do
      query { string params[:q], default_operator: "AND" } if params[:q].present?
    end
  end

  def self.search_for_client(params, client)
    tire.search(load: true, page: params[:page], per_page: 20) do
      query do
        boolean do
          must { string "client:#{client}" }
          must { string params[:q] }
        end
      end
    end
  end

  def to_indexed_json
    to_json(methods: [:index_technician, :index_client_address])
  end

  

  

  def index_technician
    user ? user.full_name : ""
  end

  
  after_initialize do |report|
    report.date ||= Date.today if report.has_attribute?(:date)
  end
  
  before_save do |report|
    report.attributes.each_pair do |name, value|
      unless ["created_at", "updated_at", "specific", "mailing_statistics", "specific_type", "user_id", "pdf_path", "id", "uid"].include? name
        report[name] = "N/A" if value.blank?
      end
    end
    if report.client == 'N/A'
      report.customer = nil
    else
      report.customer = Client.find_or_create(report.client)
    end
  end

  #after_create do
  #  Statistics.collect_statistics
  #end
#
  #after_destroy do
  #  Statistics.collect_statistics
  #end
  
  def self.results_array
    arr = []
    RESULTS.each_pair do |k, v|
      arr << [v, k]
    end
    arr
  end

  def self.is_being_edited?
    
  end

  def update_pdf_path(path)
    Report.record_timestamps = false
    self.pdf_path = path
    self.save!
    Report.record_timestamps = true
  end

  def was_mailed!(to, by)
    Report.record_timestamps = false
    mailing = Mailing.new(email: to)
    mailing.user = by
    self.mailings << mailing
    self.save!
    Report.record_timestamps = true
  end

  # returns array [when, to, by user id]
  def last_time_mailed
    self.mailings.order('created_at DESC').first
  end

  def drop_pdf_path
    Report.record_timestamps = false
    self.pdf_path = nil
    self.save!
    Report.record_timestamps = true
  end

  def accept?
    self.result == 1
  end

  def reject?
    self.result == 2
  end
  
  def self.search_by_clients(query, user)
    query = self.prepare_query(query)
    if user.client
      []
    else
      Report.find_all_by_id Report.unscoped.select('MAX(id)').where("LOWER(client) LIKE ?", query).group('client')
    end
  end

  def self.deep_dup(from, to)
    to = from.specific.deep_dup if to.class.name == from.specific_type
    to.report = from.dup
    to.report.title = "[Copy] #{to.report.title}"
    to.report.procedure = nil
    to.report.acceptance = nil
    to
  end

  def self.count_for_client(client)
    if client.class.name == "Client"
      result = Report.where(client: client.title).count
    else
      result = Report.where(client: client).count
    end
    result
  end
  
  def self.search_by_title(query, user)
    query = self.prepare_query(query)
    res = Report.where('LOWER(title) LIKE ?', query).order('created_at desc')
    res = res.where(client: user.client.title) if user.client
    res.to_a
  end
  
  def self.search_by_work_order(query, user)
    query = self.prepare_query(query)
    res = Report.where('LOWER(work_order_number) LIKE ?', query).order('created_at desc')
    res = res.where(client: user.client.title) if user.client
    res.to_a
  end
  
  def self.search_by_uid(query, user)
    query = self.prepare_query(query).gsub('-', '')
    res = Report.where('LOWER(REPLACE(uid, \'-\', \'\')) LIKE ?', query).order('created_at desc')
    res = res.where(client: user.client.title) if user.client
    res.to_a
  end

  def self.most_active_projects
    res = ActiveRecord::Base.connection.execute('SELECT COUNT(*), work_order_number FROM reports GROUP BY work_order_number')
    res.sort{|a, b| a["count"] <=> b["count"]}.reverse[0...3]
  end
  
private
  def self.prepare_query(query)
    "%#{query.strip.squeeze(' ').downcase}%"
  end
  
end
class Client < ActiveRecord::Base
	has_many :reports, foreign_key: 'customer_id'
	serialize :emails, Array
	has_many :users
	validates :name, presence: true, uniqueness: true
	default_scope order('name ASC')

	def description
		self.address.gsub(/\n/, '<br/>').html_safe if self.address
	end

	def self.most_active_clients
		Client.all.collect { |c| [c.reports.count, c.name] }.sort{ |a, b| a[0] <=> b[0] }.reverse[0...3]
	end

	def self.find_or_create(name)
		client = self.where('name = ?', name)
		if client.any?
			client = client.first
		else
			client = Client.new(name: name)
			client.approved = false
			client.save
		end
		client
	end

	def self.find_one_by_email(email)
		Client.where('emails ILIKE ? ', "%#{email}%").first
	end

	def self.suggestions_for(query)
		result = []
		clients = Client.where('name = ?', query)
		unless clients.any?
			clients = Client.where('LEVENSHTEIN(LOWER(name), ?) < 4', query.downcase)
		end
		clients.each do |client|
				result << [client.name, client.id]
			end
		result
	end

	def self.clients_list(query = '', include_unapproved = false)
		Client.select('name, notes').where('approved = ?', !include_unapproved).map(&:attributes)
	end

	def self.select_options
		Client.all.map { |u| [u.name, u.id] }
	end



	

end

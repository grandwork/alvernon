class RemoveClientBooleanFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :client
  end	
end

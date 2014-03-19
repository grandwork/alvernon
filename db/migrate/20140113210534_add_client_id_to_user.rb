class AddClientIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :client_id, :integer

  	add_index :users, :client_id
  end
end

class AddCustomerIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :customer_id, :integer
  end
end

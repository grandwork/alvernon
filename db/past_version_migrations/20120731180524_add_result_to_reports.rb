class AddResultToReports < ActiveRecord::Migration
  def change
    add_column :reports, :result, :integer, default: 0
  end
end

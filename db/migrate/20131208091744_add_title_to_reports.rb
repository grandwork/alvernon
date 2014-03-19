class AddTitleToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :title, :string
  end
end

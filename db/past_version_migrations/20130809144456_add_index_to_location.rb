class AddIndexToLocation < ActiveRecord::Migration
  def change
  	add_index :reports, :location
  end
end

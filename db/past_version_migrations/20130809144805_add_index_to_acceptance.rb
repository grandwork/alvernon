class AddIndexToAcceptance < ActiveRecord::Migration
  def change
  	add_index :reports, :acceptance
  end
end

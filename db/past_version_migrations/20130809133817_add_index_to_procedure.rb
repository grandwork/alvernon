class AddIndexToProcedure < ActiveRecord::Migration
  def change
  	add_index :reports, :procedure
  end
end

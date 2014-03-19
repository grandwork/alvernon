class AddTempToPts < ActiveRecord::Migration
  def change
    add_column :pts, :temperature, :string
  end
end
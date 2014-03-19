class AddUvWhiteAndBatchToMpis < ActiveRecord::Migration
  def change
    add_column :mpis, :uv_light, :string
    add_column :mpis, :white_light, :string
    add_column :mpis, :batch_number, :string
  end
end

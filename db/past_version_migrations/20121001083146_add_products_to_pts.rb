class AddProductsToPts < ActiveRecord::Migration
  def change
    add_column :pts, :dye_product, :string
    add_column :pts, :dev_product, :string
    add_column :pts, :cleaner_product, :string
  end
end
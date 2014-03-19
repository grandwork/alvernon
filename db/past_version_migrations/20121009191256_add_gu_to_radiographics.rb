class AddGuToRadiographics < ActiveRecord::Migration
  def change
    add_column :radiographics, :gu, :string
  end
end
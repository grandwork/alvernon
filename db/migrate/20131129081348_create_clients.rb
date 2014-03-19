class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.text :address
      t.boolean :approved, default: false, null: false

      t.timestamps
    end
  end
end

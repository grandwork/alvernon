class VisualLines < ActiveRecord::Migration
  def change
    create_table :visual_lines do |t|
      t.string :area
      t.string :level
      t.string :quantity
      t.string :result
      t.boolean :it, :default => false
      t.boolean :il, :default => false
      t.boolean :if, :default => false
      t.boolean :vc, :default => false
      t.boolean :cl, :default => false
      t.boolean :por, :default => false
      t.boolean :mw, :default => false
      t.boolean :len, :default => false
      t.boolean :cra, :default => false
      t.boolean :slg, :default => false
      t.integer :visual_id
      t.string :comments

      
      t.timestamps
    end
  end
end

class AddDefectToVisualLines < ActiveRecord::Migration
  def change
  	remove_column :visual_lines, :it
  	remove_column :visual_lines, :il
  	remove_column :visual_lines, :if
  	remove_column :visual_lines, :vc
  	remove_column :visual_lines, :cl
  	remove_column :visual_lines, :por
  	remove_column :visual_lines, :mw
  	remove_column :visual_lines, :len
  	remove_column :visual_lines, :cra
  	remove_column :visual_lines, :slg

  	add_column :visual_lines, :defect, :string
  		
  end
end

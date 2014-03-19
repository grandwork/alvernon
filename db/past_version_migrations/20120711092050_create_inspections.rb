class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.string :report_type
      t.references :report

      t.timestamps
    end
  end
end

class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :client
      t.string :uid
      t.string :job_number
      t.string :procedure
      t.string :code
      t.date   :date
      t.string :project
      t.text   :description
      t.string :client_order_number
      t.string :pdf_path
      t.string :location
      
      
      
      t.references :user
      t.references :client
      t.references :qualification
      t.references :specific, :polymorphic => {:default => "Visual"}
      
      t.timestamps
    end
  end
end

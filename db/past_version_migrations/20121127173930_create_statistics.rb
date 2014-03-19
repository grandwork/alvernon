class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :all_reports
      t.integer :ut_reports
      t.integer :mt_reports
      t.integer :pt_reports
      t.integer :rt_reports
      t.integer :et_reports
      t.integer :gt_reports
      t.string :most_active_project
      t.integer :most_active_project_count
      t.string :second_active_project
      t.integer :second_active_project_count
      t.string :third_active_project
      t.integer :third_active_project_count
      t.string :most_active_client
      t.integer :most_active_client_count
      t.string :second_active_client
      t.integer :second_active_client_count
      t.string :third_active_client
      t.integer :third_active_client_count
      t.string :most_active_user_name
      t.integer :most_active_user_id
      t.integer :most_active_user_count
      t.string :second_active_user_name
      t.integer :second_active_user_id
      t.integer :second_active_user_count
      t.string :third_active_user_name
      t.integer :third_active_user_id
      t.integer :third_active_user_count
      t.timestamps
    end
  end
end

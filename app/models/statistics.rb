class Statistics < ActiveRecord::Base

  def self.collect_statistics
    unless Rails.env == 'test'
        stat = Statistics.first || Statistics.new
        stat.all_reports = Report.count
        stat.ut_reports = Report.where(:specific_type => "Ultrasonic").count
        stat.mt_reports = Report.where(:specific_type => "Mpi").count
        stat.pt_reports = Report.where(:specific_type => "Pt").count
        stat.rt_reports = Report.where(:specific_type => "Radiographic").count
        stat.et_reports = Report.where(:specific_type => "Et").count
        stat.visual_reports = Report.where(:specific_type => "Visual").count
        stat.dt_reports = Report.where(:specific_type => "Destructive").count

        active_reports = ActiveRecord::Base.connection.execute('SELECT COUNT(*), work_order_number FROM reports GROUP BY work_order_number')
        active_reports_arr = active_reports.sort{|a, b| a["count"].to_i <=> b["count"].to_i}.reverse[0...3]
        stat.most_active_project = active_reports_arr[0]["work_order_number"]
        stat.most_active_project_count = active_reports_arr[0]["count"]
        stat.second_active_project = active_reports_arr[1]["work_order_number"]
        stat.second_active_project_count = active_reports_arr[1]["count"]
        stat.third_active_project = active_reports_arr[2]["work_order_number"]
        stat.third_active_project_count = active_reports_arr[2]["count"]


        active_clients = ActiveRecord::Base.connection.execute('SELECT COUNT(*), client FROM reports GROUP BY client')
        active_clients_arr = active_clients.sort{|a, b| a["count"].to_i <=> b["count"].to_i}.reverse[0...3]

        stat.most_active_client = active_clients_arr[0]["client"]
        stat.most_active_client_count = active_clients_arr[0]["count"]
        stat.second_active_client = active_clients_arr[1]["client"]
        stat.second_active_client_count = active_clients_arr[1]["count"]
        stat.third_active_client = active_clients_arr[2]["client"]
        stat.third_active_client_count = active_clients_arr[2]["count"]

        active_users = ActiveRecord::Base.connection.execute('SELECT COUNT(*), user_id FROM reports GROUP BY user_id')
        if active_users.count > 1
          active_users_arr = active_users.sort{|a, b| a["count"].to_i <=> b["count"].to_i}.reverse[0...3]

        stat.most_active_user_id = active_users_arr[0]["user_id"]
        stat.most_active_user_name = User.find(stat.most_active_user_id).full_name
        stat.most_active_user_count = active_users_arr[0]["count"]
        if active_users_arr.length > 1
          stat.second_active_user_id = active_users_arr[1]["user_id"]
          stat.second_active_user_name = User.find(stat.second_active_user_id).full_name
          stat.second_active_user_count = active_users_arr[1]["count"]
        end
        if active_users_arr.length > 2
          stat.third_active_user_id = active_users_arr[2]["user_id"]
          stat.third_active_user_name = User.find(stat.third_active_user_id).full_name
          stat.third_active_user_count = active_users_arr[2]["count"]
        end
        end    

        
        

        stat.save
    end
  end
end

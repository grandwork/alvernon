module ReportsHelper
  
  def header_for_search_query(object, field, query)
    prefix = object.any? ? "" : "No"
    suffix =  case field
              when 'client'
                'Reports for'
              when 'work_order'
                'Reports with work order #'
              when 'user'
                if object.any?
                  query = object.first.user.full_name
                else
                  user = User.find(query)
                  query = User.find(query).full_name if user
                end
                'Reports by'
              when 'pt_reports'
                prefix = "Liquid Penetrant Testing"
                "Reports"
              when 'ut_reports'
                "Ultrasonic Testing Reports"
              when 'visual_reports'
                "Visual Testing Reports"
              when 'rt_reports'
                "Radiographic Testing Reports"
              when 'et_reports'
                "Eddy Current Testing Reports"
              when 'mt_reports'
                "Magnetic Particle Inspection Reports"
              when 'dt_reports'
                "Destructive Testing Reports"
              when 'all'
                prefix = "All reports"
                ''
              end
    "#{prefix} #{suffix} #{query}"
  end

  def client_link_to(text, *params)
    if current_user.client
      text
    else
      link_to text, *params
    end
  end

  def text_for_mailing(mailing)
    return "This report hasn't been e-mailed yet." if mailing.nil? || mailing.user.nil?
    "Sent by e-mail to #{mailing.email} #{distance_of_time_in_words_to_now(mailing.created_at)} ago by #{mailing.user.full_name}."
  end
end

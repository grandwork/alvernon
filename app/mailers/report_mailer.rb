class ReportMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def report_email(client, sender, cc, report)
    @report = report
    @sender = sender
    @specific = report.specific
    type = report.specific_type == 'Destructive' ? 'DT' : 'NDT'
    subject = "#{type} Report ##{report.specific.uid} (#{report.title}, Order No. #{report.client_order_number})"
    attachments["Report #{@report.specific.uid}.pdf"] = File.read report.reload.pdf_path
    mail(:to => client, :from => prepare_email(@sender.email), :cc => cc,  :subject => subject)
  end

  def multiple_reports_email(clients, sender, reports, message)
    uids = []
    client_order_numbers = []
    reports.each do |r|
      report = Report.find(r)
      if r
        attachments["Report #{report.specific.uid}.pdf"] = File.read report.reload.pdf_path
        uids << report.specific.uid
        client_order_numbers << report.client_order_number
      end
    end
    Rails.logger.debug attachments.inspect
    @message = message
    subject = "#{uids.length > 1 ? 'Reports' : 'Report' } for Client order # #{client_order_numbers.uniq.join(', ')}"
    mail(to: clients, from: prepare_email(sender.email), subject: subject)
  end

  def invite_client(client, sender, link)
  	@sender = sender
  	@link = link
  	mail(to: client, from: prepare_email(@sender.email), subject: "Access to your CSI reports")
  end

  #def request_approval(report)
  #  @report = report
  #  emails = User.where(receive_dt_notification: true).collect(&:email).join(',')
  #  mail(to: emails, subject: "DT Report #{@report.uid} awaits approval")
  #end

private
  def prepare_email email
    parts = email.split('@')
    "\"#{parts[0]}\"@#{parts[1]}"
  end
end

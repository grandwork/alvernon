namespace :duplicated_uids do
  desc "Fixes the reports with duplicated uid by adding an * to the oldest uid"
  task :fix => :environment  do
    oldest_duplicated = Report.find_by_sql("select reports.* from reports inner join reports as reports2 on reports.uid=reports2.uid where reports.id != reports2.id order by reports.uid asc")
      .select { |r| r.created_at < Time.local(2013, 1, 11, 9, 0, 0) }

    oldest_duplicated.each do |report|
      puts "renaming report #{report.uid} with id #{report.id} to #{report.uid}*"
      report.uid = report.uid+"*"
      report.save
    end

    if oldest_duplicated.empty?
      puts "there are no reports with duplicated uid"
    else
      puts " ***** renamed #{oldest_duplicated.length} reports"
    end
  end

  task :list => :environment  do
    oldest_duplicated = Report.find_by_sql("select reports.* from reports inner join reports as reports2 on reports.uid=reports2.uid where reports.id != reports2.id order by reports.uid asc")
      .select { |r| r.created_at < Time.local(2013, 1, 11, 9, 0, 0) }

    oldest_duplicated.each do |report|
      puts "#{report.uid}"
    end

    if oldest_duplicated.empty?
      puts "there are no reports with duplicated uid"
    else
      puts "found #{oldest_duplicated.length} reports with duplicated uid"
    end
  end
end
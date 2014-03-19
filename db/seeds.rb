# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Report.delete_all
Client.delete_all
Qualification.delete_all
#Mpi.delete_all
#Ultrasonic.delete_all

admin = User.new do |u|
  u.email = "rebel.colony@csindi.com"
  u.password = "secret"
  u.password_confirmation = "secret"
  u.admin = true
  u.super_admin = true
end
 
  user = User.new do |u|
   u.email = "john.doe@csindi.com"
   u.password = "secret"
   u.password_confirmation = "secret"
  end

  user2 = User.new do |u|
   u.email = "matt.damon@csindi.com"
   u.password = "secret"
   u.password_confirmation = "secret"
  end

  user3 = User.new do |u|
   u.email = "beverly.hills@csindi.com"
   u.password = "secret"
   u.password_confirmation = "secret"
  end

  user4 = User.new do |u|
   u.email = "brad.pitt@csindi.com"
   u.password = "secret"
   u.password_confirmation = "secret"
  end

client1 = Client.new do |c|  
  c.name = "ACME Corporation"
  c.address = "123, Elm St, New York"
  c.approved = true
end

client2 = Client.new do |c|
  c.name = "NASA"
  c.address = "987 Houston, TX"
end

qual1 = Qualification.new do |q|
  q.name = "Ultrasonics"
  q.level = "2"
  q.number = "UY564533"
  q.user_id = admin.id
end
 

 

# report = Report.new do |r|
#   r.procedure = "APP - QP - 7"
#   r.acceptance = "ISO 5817"
#   r.date_of_inspection = Date.today
#   r.description = "Description"
#   r.client = "Keepel Norway AS"
#   r.location = "Dusavik"
#   r.drawing_number = "N/A"
#   r.part_number = "A100974-14"
#   r.title = "Welding Procedure Qualification, 2pcs."
#   r.weld_number = "4-5"
#   r.welder = "KN03, KN07"
#   r.material = "C/S"
#   r.dimension = "88 mm"
#   r.thickness = "15 mm"
#   r.surface_condition = "As welded"
#   r.welding_process = "141"
#   r.joint_type = "Butt weld"
#   r.control_extent = "100%"
#   r.work_order_number = "WPQ 164"
#   r.user = user
# end


  #r = Report.create(:user_id => 1, :specific_id => 1, :specific_type => "Mpi")
  #r.save!

 
# 
# defect = MpiDefect.new do |d|
#   d.scope = "Short"
#   d.start = "3mm"
#   d.length = "12mm"
#   d.defect_type = "C-ROOT"
#   d.result = "Some result here"
# end
# 
# 
# 
# mpi = Mpi.new do |m|
#   m.equipment = "Yoke"
#   m.type_of_powder = "Black ink - wet"
#   m.current = "240 V - AC"
#   m.contrast = "White paint"
#   m.field_strength = "4.5 kg min lift / 2.4-4.0 kA/M"
#   m.pole_spacing = "75 - 200 mm"
#   m.report = report
# end
# 
# mpi.mpi_defects << defect
# 
# report2 = Report.new do |r|
#   r.procedure = "APP - QP - 09-WOR Rev. 1"
#   r.acceptance = "SPC 60015744/ISO 13628-7 tbl.18"
#   r.date_of_inspection = Date.today
#   r.description = "Description"
#   r.client = "Aarbakke A/S"
#   r.location = "Karratha"
#   r.drawing_number = "N/A"
#   r.part_number = "A100974-14"
#   r.title = "Welding Procedure Qualification, 2pcs."
#   r.weld_number = "4-5"
#   r.welder = "KN03, KN07"
#   r.material = "C/S"
#   r.dimension = "88 mm"
#   r.thickness = "15 mm"
#   r.surface_condition = "As welded"
#   r.welding_process = "141"
#   r.joint_type = "Butt weld"
#   r.control_extent = "100%"
#   r.work_order_number = "WPQ 164" 
#   r.user = user
# end
# 
# mpi2 = Mpi.new do |m|
#   m.equipment = "Yoke"
#   m.type_of_powder = "Black ink - wet"
#   m.current = "240 V - AC"
#   m.contrast = "White paint"
#   m.field_strength = "4.5 kg min lift / 2.4-4.0 kA/M"
#   m.pole_spacing = "75 - 200 mm"
#   m.report = report2
# end

admin.save!
user.save!
user2.save!
user3.save!
user4.save!
client1.save!
client2.save!
qual1.save!


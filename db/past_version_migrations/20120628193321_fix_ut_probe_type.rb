class FixUtProbeType < ActiveRecord::Migration
  def up
  	change_table :ut_probes do |t|
  		t.rename :type, :probe_type
  	end
  end

  def down
  	change_table :ut_probes do |t|
  		t.rename :probe_type, :type
  	end
  end
end

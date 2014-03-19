class CreateEtProbes < ActiveRecord::Migration
  def change
    create_table :et_probes do |t|
      t.string :frequency
      t.string :probe_type
      t.string :mode
      t.string :serial
      t.string :gain
      t.string :phase
      t.string :sensitivity
      t.references :et

      t.timestamps
    end
  end
end

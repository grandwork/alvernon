class CreateMpiDefects < ActiveRecord::Migration
  def change
    create_table :mpi_defects do |t|
      t.references :mpi
      t.string :scope
      t.string :start
      t.string :length
      t.string :defect_type
      t.string :result
      t.timestamps
    end
  end
end

class CreateMailings < ActiveRecord::Migration
  def change
    create_table :mailings do |t|
      t.string :email
      t.references :report
      t.references :user

      t.timestamps
    end
  end
end

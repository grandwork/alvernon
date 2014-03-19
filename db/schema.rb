# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140113210959) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.boolean  "approved",   :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "image_attachments", :force => true do |t|
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mailings", :force => true do |t|
    t.string   "email"
    t.integer  "report_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "qualifications", :force => true do |t|
    t.string   "number"
    t.string   "name"
    t.string   "level"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "client"
    t.string   "uid"
    t.string   "job_number"
    t.string   "procedure"
    t.string   "code"
    t.date     "date"
    t.string   "project"
    t.text     "description"
    t.string   "client_order_number"
    t.string   "pdf_path"
    t.string   "location"
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "qualification_id"
    t.integer  "specific_id"
    t.string   "specific_type",       :default => "Visual"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "title"
    t.integer  "result",              :default => 0
    t.integer  "customer_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "admin",                                :default => false
    t.boolean  "super_admin",                          :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "signature"
    t.datetime "deleted_at"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "client_id"
  end

  add_index "users", ["client_id"], :name => "index_users_on_client_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visual_lines", :force => true do |t|
    t.string   "area"
    t.string   "level"
    t.string   "quantity"
    t.string   "result"
    t.integer  "visual_id"
    t.string   "comments"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "defect"
  end

  create_table "visuals", :force => true do |t|
    t.integer  "report_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

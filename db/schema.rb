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

ActiveRecord::Schema.define(:version => 20121219131245) do

  create_table "jobs", :force => true do |t|
    t.string   "jobtitle"
    t.string   "location"
    t.text     "description"
    t.text     "apply_details"
    t.string   "company_name"
    t.string   "company_website"
    t.string   "confirmation_email"
    t.decimal  "salary",              :precision => 10, :scale => 2
    t.string   "jobtype"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "jobkey"
    t.string   "jobkey_confirmation"
    t.integer  "isdeleted"
    t.integer  "category"
  end

  add_index "jobs", ["jobkey"], :name => "index_jobs_on_jobkey"
  add_index "jobs", ["jobtitle"], :name => "index_jobs_on_jobtitle"
  add_index "jobs", ["jobtype"], :name => "index_jobs_on_jobtype"
  add_index "jobs", ["location"], :name => "index_jobs_on_location"
  add_index "jobs", ["salary"], :name => "index_jobs_on_salary"

  create_table "lecture_sessions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lecture_sessions", ["name"], :name => "index_lecture_sessions_on_name"

  create_table "schedules", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "lecture_session_id"
    t.string   "frequency"
    t.time     "start_time"
    t.integer  "time_interval"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "schedules", ["lecture_session_id"], :name => "index_schedules_on_lecture_session_id"
  add_index "schedules", ["teacher_id"], :name => "index_schedules_on_teacher_id"

  create_table "teachers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "teachers", ["name"], :name => "index_teachers_on_name"

end

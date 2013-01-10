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

ActiveRecord::Schema.define(:version => 20130110164217) do

  create_table "accesses", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "course_id"
  end

  create_table "assignment_types", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.text     "description"
    t.decimal  "worth"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "drop_lowest", :default => false
  end

  create_table "assignments", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.decimal "worth"
    t.decimal "assignment_type_id"
    t.date    "due_date"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.integer  "section"
    t.text     "description"
    t.integer  "pin"
    t.boolean  "student_managed"
    t.decimal  "credits"
    t.boolean  "points_based"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "professor_id"
    t.integer  "school_id"
  end

  create_table "grade_scales", :force => true do |t|
    t.integer  "course_id"
    t.decimal  "a"
    t.decimal  "a_minus"
    t.decimal  "b_plus"
    t.decimal  "b"
    t.decimal  "b_minus"
    t.decimal  "c_plus"
    t.decimal  "c"
    t.decimal  "c_minus"
    t.decimal  "d_plus"
    t.decimal  "d"
    t.decimal  "d_minus"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "due_date"
  end

  create_table "grades", :force => true do |t|
    t.decimal  "grade"
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "professors", :force => true do |t|
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.string   "css_class"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.text     "password_hash"
    t.text     "password_salt"
    t.integer  "theme_id"
    t.string   "confirmation_code"
    t.boolean  "enabled",           :default => true, :null => false
  end

end

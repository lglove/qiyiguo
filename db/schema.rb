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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160504145812) do

  create_table "admin_videos", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "password",   limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "designers", force: :cascade do |t|
    t.string   "name",        limit: 45
    t.string   "email",       limit: 255
    t.text     "description", limit: 65535
    t.string   "mobilephone", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "price",       limit: 4
    t.string   "name",        limit: 255
    t.string   "mobilephone", limit: 45
    t.string   "status",      limit: 255
    t.string   "express",     limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "user_addresses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_infos", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "height",       limit: 255
    t.string   "weight",       limit: 255
    t.string   "shangyichima", limit: 255
    t.string   "yaowei",       limit: 255
    t.string   "bichang",      limit: 255
    t.string   "jiankuan",     limit: 255
    t.string   "xiongwei",     limit: 255
    t.string   "datuiwei",     limit: 255
    t.string   "kuchang",      limit: 255
    t.string   "xiema",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "invite_id",     limit: 4
    t.string   "name",          limit: 255
    t.string   "mobilephone",   limit: 255
    t.integer  "age",           limit: 4
    t.string   "sex",           limit: 255
    t.string   "birthday",      limit: 255
    t.string   "email",         limit: 255
    t.string   "password",      limit: 255
    t.string   "youxiang",      limit: 255
    t.string   "invitecode",    limit: 255
    t.integer  "amount",        limit: 4
    t.integer  "invite_amount", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end

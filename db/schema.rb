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

ActiveRecord::Schema.define(:version => 20130630131835) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "booking_histories", :force => true do |t|
    t.integer  "booking_id", :null => false
    t.integer  "user_id",    :null => false
    t.string   "old_status"
    t.string   "new_status"
    t.datetime "date"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "message_id",                        :null => false
    t.integer  "user_id",                           :null => false
    t.integer  "guide_id",                          :null => false
    t.integer  "price",                             :null => false
    t.string   "status",     :default => "OFFERED"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "country_name"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "guides_count", :default => 0, :null => false
    t.string   "slug"
  end

  add_index "cities", ["slug"], :name => "index_cities_on_slug"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "rating"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "guide_images", :force => true do |t|
    t.integer  "guide_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "guides", :force => true do |t|
    t.text     "short_introduction"
    t.text     "long_introduction"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "is_professional"
    t.integer  "positive_review_count",      :default => 0,     :null => false
    t.integer  "negative_review_count",      :default => 0,     :null => false
    t.float    "positive_review_proportion", :default => 0.0,   :null => false
    t.string   "slug"
    t.float    "rate",                       :default => 0.0,   :null => false
    t.integer  "completeness_score",         :default => 0,     :null => false
    t.boolean  "is_phone_verified",          :default => false, :null => false
    t.boolean  "is_regmail_sent",            :default => false, :null => false
  end

  add_index "guides", ["slug"], :name => "index_guides_on_slug"

  create_table "guides_interests", :id => false, :force => true do |t|
    t.integer "guide_id"
    t.integer "interest_id"
  end

  add_index "guides_interests", ["guide_id", "interest_id"], :name => "index_guides_interests_on_guide_id_and_interest_id"

  create_table "guides_transportation_methods", :id => false, :force => true do |t|
    t.integer "guide_id"
    t.integer "transportation_method_id"
  end

  add_index "guides_transportation_methods", ["guide_id", "transportation_method_id"], :name => "guides_transportation_methods_index", :unique => true

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "language_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "location_search_details", :force => true do |t|
    t.string   "ip",                 :null => false
    t.integer  "user_id"
    t.integer  "location_search_id", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "location_searches", :force => true do |t|
    t.string   "query",                       :null => false
    t.integer  "search_count", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "location_searches", ["query"], :name => "index_location_searches_on_query"

  create_table "message_threads", :force => true do |t|
    t.integer  "sender_id",                              :null => false
    t.integer  "receiver_id",                            :null => false
    t.boolean  "deleted_by_sender",   :default => false
    t.boolean  "deleted_by_receiver", :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "message_thread_id"
    t.integer  "sender_id",                                     :null => false
    t.integer  "receiver_id",                                   :null => false
    t.text     "message_text",                                  :null => false
    t.integer  "modified_booking_id"
    t.string   "status",                  :default => "UNREAD", :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "guide_id"
    t.integer  "service_id"
    t.float    "rate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "icon_css_class"
    t.text     "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spoken_languages", :force => true do |t|
    t.integer  "guide_id"
    t.integer  "language_id"
    t.integer  "language_level_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "transportation_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "is_admin"
    t.integer  "guide_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "oauth_provider"
    t.string   "oauth_uid"
    t.string   "oauth_name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "sex"
    t.integer  "fb_friend_count"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  create_table "users_cities", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "city_id"
  end

  add_index "users_cities", ["city_id", "user_id"], :name => "index_users_cities_on_city_id_and_user_id"
  add_index "users_cities", ["user_id", "city_id"], :name => "index_users_cities_on_user_id_and_city_id"

end

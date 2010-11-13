# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100721230431) do

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dialogues", :force => true do |t|
    t.string   "dialogue_type"
    t.text     "body"
    t.text     "title"
    t.integer  "project_id"
    t.boolean  "is_project_update",    :default => false
    t.string   "author"
    t.boolean  "is_reply",             :default => false
    t.boolean  "show",                 :default => true
    t.integer  "dialogue_id"
    t.integer  "parent_id"
    t.integer  "research_association"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "email",       :null => false
    t.integer  "project_id",  :null => false
    t.string   "token"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "url",              :null => false
    t.string   "title"
    t.integer  "research_item_id"
    t.datetime "created_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.boolean  "deleted_user"
    t.boolean  "deleted_reciever"
    t.boolean  "archived"
    t.datetime "read_at"
    t.datetime "updated_at"
  end

  create_table "participants", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "profile_id"
    t.string  "role",       :null => false
  end

  add_index "participants", ["project_id", "user_id"], :name => "index_participants_on_project_id_and_user_id"
  add_index "participants", ["user_id"], :name => "index_participants_on_user_id"

  create_table "profiles", :force => true do |t|
    t.string   "firstname",                           :null => false
    t.string   "lastname",                            :null => false
    t.string   "middleinitial",       :limit => 1
    t.string   "email",                               :null => false
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode",             :limit => 5
    t.string   "timezone"
    t.integer  "user_id",                             :null => false
    t.string   "headline"
    t.string   "summary",             :limit => 3000
    t.datetime "created_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "projectname",                                                                                                                                                                                                                                                                                                                                     :null => false
    t.boolean  "is_code_name",                        :default => true
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "project_location",                                                                                                                                                                                                                                                                                                                                :null => false
    t.integer  "current_hurdle",                      :default => 1
    t.string   "project_teaser",      :limit => 330,  :default => "This is where you enter the teaser for your project that is displayed in the public project gallery.",                                                                                                                                                                                         :null => false
    t.string   "project_about",       :limit => 7200, :default => "This is where you enter the full description of your project that is seen by community members that are not participating in your project.  As such, please make sure that your description does not include information that you would consider sensitive in a public or semi-public forum."
    t.text     "about_embed"
    t.string   "project_description",                 :default => "This is where you enter the detailed description of your project and goals for use by the participants of your project."
    t.text     "desc_embed"
    t.boolean  "is_plan_complete",                    :default => false
    t.boolean  "is_team_complete",                    :default => false
    t.boolean  "is_mentor_complete",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "research_items", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.integer  "research_item_id"
    t.datetime "created_at"
    t.string   "rssurl"
    t.integer  "created_by"
    t.integer  "project_id"
    t.integer  "dialogue_association"
  end

  create_table "research_libraries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "research_tag_associations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "research_id"
    t.integer  "tag_id"
  end

  create_table "tag_associations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag1"
    t.integer  "tag2"
  end

  create_table "tags", :force => true do |t|
    t.string   "tagtext",          :null => false
    t.integer  "research_item_id"
    t.datetime "created_at"
    t.integer  "created_by"
  end

  create_table "updates", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token"
    t.integer  "login_count",       :default => 0
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end

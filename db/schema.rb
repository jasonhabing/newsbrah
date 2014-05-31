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

ActiveRecord::Schema.define(:version => 20140531022322) do

  create_table "big_stories", :force => true do |t|
    t.string   "title"
    t.string   "image"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "breakingdate"
    t.datetime "latestdate"
    t.float    "score"
    t.integer  "bestfeed"
    t.integer  "published"
    t.text     "description"
    t.text     "imageurl"
    t.text     "imageattr"
  end

  create_table "feed_items", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "published"
    t.string   "author"
    t.string   "summary"
    t.string   "content"
    t.string   "categories"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "guid"
    t.string   "feedsource"
    t.integer  "big_story_id"
    t.string   "imageurl"
    t.text     "desc",         :limit => 255
  end

  create_table "images", :force => true do |t|
    t.string   "sourceurl"
    t.string   "localcopy"
    t.integer  "big_story_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "feed_item_id"
  end

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "rss"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "logo"
  end

  create_table "title_words", :force => true do |t|
    t.integer  "feeditemid"
    t.string   "word1"
    t.string   "word2"
    t.string   "word3"
    t.string   "word4"
    t.string   "word5"
    t.string   "word6"
    t.string   "word7"
    t.string   "word8"
    t.string   "word9"
    t.string   "word10"
    t.string   "word11"
    t.string   "word12"
    t.string   "word13"
    t.string   "word14"
    t.string   "word15"
    t.string   "word16"
    t.string   "word17"
    t.string   "word18"
    t.string   "word19"
    t.string   "word20"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

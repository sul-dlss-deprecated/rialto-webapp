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

ActiveRecord::Schema.define(version: 2018_11_21_152008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "plpgsql"

  create_table "bookmarks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "concepts", primary_key: "uri", id: :string, force: :cascade do |t|
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", primary_key: "uri", id: :string, force: :cascade do |t|
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index "((metadata ->> 'department'::text))", name: "index_organizations_on_metadata_department", using: :hash
    t.index "((metadata ->> 'type'::text))", name: "index_organizations_on_metadata_type", using: :hash
    t.index ["name"], name: "index_organizations_on_name"
  end

  create_table "people", primary_key: "uri", id: :string, force: :cascade do |t|
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index "((metadata ->> 'departments'::text))", name: "index_people_on_metadata_departments", using: :gin
    t.index "((metadata ->> 'schools'::text))", name: "index_people_on_metadata_schools", using: :gin
    t.index ["name"], name: "index_people_on_name"
  end

  create_table "people_publications", id: false, force: :cascade do |t|
    t.string "person_uri", null: false
    t.string "publication_uri", null: false
    t.index ["publication_uri", "person_uri"], name: "pub_person_uk", unique: true
  end

  create_table "publications", primary_key: "uri", id: :string, force: :cascade do |t|
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "(((metadata ->> 'created_year'::text))::numeric)", name: "index_publications_on_metadata_created_year_numeric"
    t.index "((metadata ->> 'concepts'::text))", name: "index_publications_on_metadata_concepts", using: :gin
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

end

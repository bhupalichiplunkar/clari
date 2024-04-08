# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_01_163522) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "fb_account_id"
    t.string "fb_account_string"
    t.string "account_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_account_id", "fb_account_string"], name: "index_accounts_on_fb_account_id_and_fb_account_string"
  end

  create_table "ads", force: :cascade do |t|
    t.bigint "fb_ad_id"
    t.string "ad_name"
    t.string "landing_page"
    t.string "ad_type"
    t.string "ad_format"
    t.datetime "start_date"
    t.string "facebook_post"
    t.string "instagram_post"
    t.bigint "adset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_ad_id", "adset_id"], name: "index_ads_on_fb_ad_id_and_adset_id"
  end

  create_table "adsets", force: :cascade do |t|
    t.bigint "fb_adset_id"
    t.string "adset_name"
    t.string "optimization_goal"
    t.datetime "start_date"
    t.float "daily_budget"
    t.float "lifetime_budget"
    t.string "billing_event"
    t.string "bid_strategy"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_adset_id", "campaign_id"], name: "index_adsets_on_fb_adset_id_and_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "fb_campaign_id"
    t.string "campaign_name"
    t.string "campaign_objective"
    t.datetime "start_date"
    t.float "daily_budget"
    t.float "lifetime_budget"
    t.string "buying_type"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_campaign_id", "account_id"], name: "index_campaigns_on_fb_campaign_id_and_account_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "campaign_id"
    t.bigint "adset_id"
    t.bigint "ad_id"
    t.integer "all_clicks"
    t.float "all_ctr"
    t.integer "link_clicks"
    t.float "ctr_link_clicks"
    t.float "cplc"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.integer "landing_page_views"
    t.integer "mobile_app_installs"
    t.integer "video_plays"
    t.datetime "attr_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "revenue"
    t.index ["account_id", "campaign_id", "adset_id", "ad_id", "attr_date"], name: "idx_on_account_id_campaign_id_adset_id_ad_id_attr_d_8ad3f1ded1"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

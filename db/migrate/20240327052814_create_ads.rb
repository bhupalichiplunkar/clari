class CreateAds < ActiveRecord::Migration[7.1]
  def change
    create_table :ads do |t|
      t.bigint :fb_ad_id
      t.string :ad_name
      t.string :landing_page
      t.string :ad_type
      t.string :ad_format
      t.datetime :start_date
      t.string :facebook_post
      t.string :instagram_post
      t.bigint :adset_id
      t.timestamps
    end

    add_index :ads, [:fb_ad_id, :adset_id]
  end

  def down
    def change
      remove_index :ads, [:fb_ad_id, :adset_id]
    end
  end
end

#Columns: id (Primary Key), name, landing_page, ad_type, ad_format, start_date, facebook_post, instagram_post, ad_set_id 
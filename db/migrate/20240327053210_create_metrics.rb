class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.bigint :account_id
      t.bigint :campaign_id
      t.bigint :adset_id
      t.bigint :ad_id
      t.integer :all_clicks
      t.float :all_ctr
      t.integer :link_clicks
      t.float :ctr_link_clicks
      t.float :cplc
      t.integer :comments
      t.integer :impressions 
      t.integer :likes
      t.float :spend
      t.integer :landing_page_views
      t.integer :mobile_app_installs
      t.integer :video_plays
      t.datetime :attr_date
      t.timestamps
    end

    add_index :metrics, [ :account_id, :campaign_id, :adset_id, :ad_id, :attr_date]
  end

  def down
    def change
      remove_index :metrics, [ :account_id, :campaign_id, :adset_id, :ad_id, :attr_date]
    end
  end
end

#Columns: id (Primary Key), date, account_id, campaign_id, ad_set_id, ad_id, all_clicks, all_ctr, link_clicks, ctr_link_clicks, cplc, comments, impressions, likes, spend, landing_page_views, mobile_app_installs, video_plays
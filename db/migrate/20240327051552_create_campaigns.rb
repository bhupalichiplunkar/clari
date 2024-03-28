class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns do |t|
      t.bigint :fb_campaign_id
      t.string :campaign_name
      t.string :campaign_objective
      t.datetime :start_date
      t.float :daily_budget
      t.float :lifetime_budget
      t.string :buying_type
      t.bigint :account_id
      t.timestamps
    end

    add_index :campaigns, [:fb_campaign_id, :account_id]
  end
  
  def down
    def change
      remove_index :campaigns, [:fb_campaign_id, :account_id]
    end
  end
end
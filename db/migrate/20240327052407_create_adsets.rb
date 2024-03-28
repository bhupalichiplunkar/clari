class CreateAdsets < ActiveRecord::Migration[7.1]
  def change
    create_table :adsets do |t|
      t.bigint :fb_adset_id
      t.string :adset_name
      t.string :optimization_goal
      t.datetime :start_date
      t.float :daily_budget
      t.float :lifetime_budget
      t.string :billing_event
      t.string :bid_strategy
      t.bigint :campaign_id
      t.timestamps
    end

    add_index :adsets, [:fb_adset_id, :campaign_id]
  end

  def down
    def change
      remove_index :adsets, [:fb_adset_id, :campaign_id]
    end
  end
end
# Columns: id (Primary Key), name, optimization_goal, start_date, daily_budget, lifetime_budget, billing_event, bid_strategy, campaign_id (Foreign Key referencing Campaigns table)
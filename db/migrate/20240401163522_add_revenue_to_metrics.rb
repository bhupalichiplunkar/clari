class AddRevenueToMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :metrics, :revenue, :bigint
  end
end

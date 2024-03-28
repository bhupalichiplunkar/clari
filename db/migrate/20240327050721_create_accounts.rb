class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.bigint :fb_account_id
      t.string :fb_account_string
      t.string :account_name
      t.timestamps
    end

    add_index :accounts, [:fb_account_id, :fb_account_string]
  end

  def down
    def change
      remove_index :accounts, [:fb_account_id, :fb_account_string]
    end
  end
end

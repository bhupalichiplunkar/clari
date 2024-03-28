class Account < ApplicationRecord
    has_many :campaigns 
    has_many :metrics
    has_many :adsets, through: :campaigns
    validates :fb_account_id, presence:true
    validates :fb_account_string, presence:true
end
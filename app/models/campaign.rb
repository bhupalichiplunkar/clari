class Campaign < ApplicationRecord
    belongs_to :account
    has_many :adsets
    has_many :metrics
    has_many :ads, through: :adsets 
    validates :fb_campaign_id, presence:true
end
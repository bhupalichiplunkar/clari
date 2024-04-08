class Campaign < ApplicationRecord
    belongs_to :account
    has_many :adsets
    validates :fb_campaign_id, presence:true
end
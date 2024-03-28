class Ad < ApplicationRecord
    belongs_to :adset
    has_many :metrics
    validates :fb_ad_id, presence:true
end
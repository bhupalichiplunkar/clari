class Ad < ApplicationRecord
    belongs_to :adset
    validates :fb_ad_id, presence:true
end
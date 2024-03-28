class Adset < ApplicationRecord
    belongs_to :campaign
    has_many :ads 
    has_many :metrics
    validates :fb_adset_id, presence:true
end
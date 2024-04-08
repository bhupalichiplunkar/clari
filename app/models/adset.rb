class Adset < ApplicationRecord
    belongs_to :campaign
    has_many :ads
    validates :fb_adset_id, presence:true
end
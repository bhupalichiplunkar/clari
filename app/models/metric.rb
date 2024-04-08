class Metric < ApplicationRecord
    belongs_to :account
    belongs_to :campaign
    belongs_to :adset
    belongs_to :ad
end
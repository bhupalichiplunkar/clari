require_relative '../../lib/facebook_module'

class IngestFbCampaignsJob
  include Sidekiq::Job
  include FacebookModule

  def perform(*args)
    fetch_all_campaigns
  end
end

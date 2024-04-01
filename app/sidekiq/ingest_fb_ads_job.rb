require_relative '../../lib/facebook_module'

class IngestFbAdsJob
  include Sidekiq::Job
  include FacebookModule

  def perform(*args)
    # fetch_all_ads
    fetch_all_ads_metrics
  end
end

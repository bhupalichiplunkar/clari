require_relative '../../lib/facebook_module'

class IngestFbAdsetsJob
  include Sidekiq::Job
  include FacebookModule

  def perform(*args)
    # fetch_all_adsets
    fetch_all_adsets_metrics
  end
end

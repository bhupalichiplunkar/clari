require_relative '../../lib/facebook_module'

class IngestFbAccountMetricsJob
  include Sidekiq::Job
  include FacebookModule

  def perform(*args)
    puts " blah"
  end
end

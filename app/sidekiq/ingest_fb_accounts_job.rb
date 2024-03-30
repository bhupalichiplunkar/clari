require_relative '../../lib/facebook_module'

class IngestFbAccountsJob
  include Sidekiq::Job
  include FacebookModule

  def perform(*args)
    fetch_all_accounts
  end
end

require_relative '../../lib/upload_module'

class IngestCsvFileJob
  include Sidekiq::Job
  include UploadModule

  def perform(csv_file)
    upload_csv_file(csv_file)
  end
end

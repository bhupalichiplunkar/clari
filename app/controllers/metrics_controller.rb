

class MetricsController < ApplicationController
  include Pagy::Backend

  after_action { pagy_headers_merge(@pagy) if @pagy }

  def upload_csv
    begin
      file = params["file"]
      temp_file_path = save_temporary_file(file)
      IngestCsvFileJob.perform_async(temp_file_path)
      render json:{
          status: 200, 
          message: "Job queued to upload csv"
      }
    rescue StandardError => error
      p "=========>", error
      render json: {
          status: 400, 
          message: "failed to queue job to upload csv"
      }
    end
  end

  def fetch_table_wise_column_names
    exclude_columns = ["id", "created_at", "updated_at", "ad_name", "campaign_name", "adset_name", "name", "fb_campaign_id", "fb_adset_id", "fb_ad_id", "ad_id", "campaign_id", "adset_id", "account_id", "start_date"]

    tables_supported = ['campaigns', 'adsets', 'ads', 'metrics']

    columns = {}

    tables_supported.each do |table_name|
      table = case table_name
      when "campaigns"
        Campaign
      when "adsets"
        Adset
      when "ads"
        Ad
      when "metrics"
        Metric
      else
        nil
      end

      dimensions = table.columns.reject { |column| exclude_columns.include?(column.name) }
      
      columns[table_name] = dimensions.map do |column|
        {
          key: column.name,
          value: column.name.gsub("_", " ").capitalize, 
          type: column.type 
        }
      end
    end

    render json: { column_names: columns }
  end

  def fetch_metric_names
    exclude_columns = ["id", "created_at", "updated_at", "ad_id", "campaign_id", "adset_id", "account_id", "start_date"]
    metrics = Metric.column_names.reject { |column| exclude_columns.include?(column) }
    metric_names = metrics.map do |column_name|
      {
        key: column_name,
        value: column_name.gsub("_", " ").capitalize
      }
    end
    render json: { status: 200, metric_names:  metric_names}
  end 

  def get_dimension_or_metric_values
    dimension_channel = params[:channel]
    dimension_name = params[:dimension_name] # Assuming the column name is passed as a parameter
    partial_value = params[:partial_value] # Partial value entered by the user
    channel = nil
    channel = Campaign if dimension_channel == 'campaigns'
    channel = Adset if dimension_channel == 'adsets'
    channel = Ad if dimension_channel == 'ads'
    channel = Metric if dimension_channel == 'metrics'
    
    if channel && channel.column_names.include?(dimension_name)
      values = channel.where("#{dimension_name} ILIKE ?", "%#{partial_value}%").distinct.pluck(dimension_name)
      column_values = values.map do|value|
        {
        key: value,
        value: value
      }
      end
      render json: { status: 200, column_values: column_values }
    else
      render json: { status: 200, column_values: [], message: "No values found" }
    end
  end

  def query_data
    tables_supported = ['campaigns', 'adsets', 'ads', 'metrics']
    begin
      start_date = Time.zone.parse(params[:start_date]).beginning_of_day
      end_date = Time.zone.parse(params[:end_date]).end_of_day
      conditions = params[:conditions]
      metrics = params[:column_values]
      

      base_query = Metric.joins(:account, :campaign, :adset, :ad)
                        .where("DATE(metrics.attr_date) BETWEEN ? AND ?", start_date.to_date, end_date.to_date)

      conditions_column = []

      conditions.each do |condition|

        table_name, column_name, value, operator = condition.values_at(:table, :column, :value, :operator)
        
        if tables_supported.include?(table_name)
          table_column = "#{table_name}.#{column_name}"

          base_query = operator == "IN" ? 
                        base_query.where("#{table_column} IN (?)", value) 
                        : base_query.where("#{table_column} #{operator} ?", value)

          conditions_column << table_column

        end 
      end


      # Select specified column values from Metrics table
      result = base_query
               .select(metrics.map { |c| "metrics.#{c}" })
               .select("metrics.id", "ads.ad_name","adsets.adset_name", "campaigns.campaign_name","accounts.account_name")
               .select(conditions_column)

      pagy, records = pagy(result)
      pagination = pagy_metadata(pagy)
      page = pagination.extract! :prev_url, :next_url, :count, :page, :next
            
      render json:{
        status: 200, 
        data: records, 
        page: page,
      }

    rescue StandardError => e
      p e
      render json: {
        status: 400,
        data: [], 
        page: {},
        message: "failed to fetch data"
      }
    end
  end

  def save_temporary_file(file)
    temp_file = Tempfile.new('uploaded_csv')
    temp_file.binmode
    temp_file.write(file.read)
    temp_file.rewind
    temp_file.path
  ensure
    temp_file.close
  end

end
class CampaignsController < ApplicationController
    include Pagy::Backend

    after_action { pagy_headers_merge(@pagy) if @pagy }

    def index
        begin
            campaigns = !params["account_id"].nil? ? Campaign.where(account_id: params["account_id"]) : Campaign.all
            pagy, records = pagy(campaigns)
            pagination = pagy_metadata(pagy)
            page = pagination.extract! :prev_url, :next_url, :count, :page, :next
            
            render json:{
                status: 200, 
                data: records, 
                page: page,
            }
        rescue StandardError => error
            p "=========>", error
            render json: {
                status: 400, 
                message: "failed to get campaigns for account #{params["account_id"]}"
            }
        end
    end
end 
class AdsetsController < ApplicationController
    include Pagy::Backend

    after_action { pagy_headers_merge(@pagy) if @pagy }

    def index
        begin
            adsets = !params["campaign_id"].nil? ? Adset.where(campaign_id: params["campaign_id"]) : Adset.all
            pagy, records = pagy(adsets)
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
                message: "failed to get adsets for campaign #{params["campaign_id"]}"
            }
        end
    end
end 
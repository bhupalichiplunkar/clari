class AdsController < ApplicationController
    include Pagy::Backend

    after_action { pagy_headers_merge(@pagy) if @pagy }

    def index
        begin
            ads = !params["adset_id"].nil? ? Ad.where(adset_id: params["adset_id"]) : Ad.all
            pagy, records = pagy(ads)
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
                message: "failed to fetch ads for adset #{params["adset_id"]}"
            }
        end
    end
end 
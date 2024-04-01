class AccountsController < ApplicationController
    include Pagy::Backend

    after_action { pagy_headers_merge(@pagy) if @pagy }

    def index
        begin
            pagy, records = pagy(Account.all)
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
                message: "failed to fetch accounts"
            }
        end
    end
end 
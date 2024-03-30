require_relative '../../lib/facebook_module'
 
 class FacebookController < ApplicationController
    include FacebookModule
    
    def save_and_fetch(response, type = nil, id = nil)
        if type == 'accounts'
            save_accounts (response["data"])
            return Account.all  
        elsif type == 'campaigns'
            save_campaigns(response["data"], id)
            return Campaign.all
        elsif type == 'adsets'
            save_adsets(response["data"], id)
            return Adset.all
        elsif type == 'ads'
            save_ads(response["data"], id)
            return Ad.all
        else
            return response
        end
    end

    def process_and_send_result(response, type = nil, id = nil)
        if response.class == Hash && response.has_key?('data') && response["data"] != nil
            data = save_and_fetch(response, type, id)
            result = {status: 200}.merge({:data => data})
            render json: result
        else
            render json: {
                status: 400,
                message: response
            }
        end
    end


    def fetch_accounts
        response = get_accounts
        process_and_send_result(response, 'accounts')
    end

    def fetch_campaigns
        account_id = params[:account_id]
        response = get_campaigns(account_id)
        process_and_send_result(response, 'campaigns', account_id) 
    end

    
    def fetch_adsets
        campaign_id = params[:campaign_id]
        response = get_adsets(campaign_id)
        process_and_send_result(response, 'adsets', campaign_id)
    end


    def fetch_ads
         adset_id = params[:adset_id]
         response = get_ads(adset_id)
         process_and_send_result(response, 'ads', adset_id)
        
    end

    def fetch_metrics
        level = params[:level]
        id = params[:id]
        response = get_metrics(level, id)
        process_and_send_result(response)
    end

    # def fetch_campaigns_for_all_accounts
    #     begin
    #         Account.in_batches.each do |accounts|
    #             accounts.each do |account|
    #                 account_id = account["fb_account_string"]
    #                 fk_account_id = account["id"]
    #                 # p "starting for #{fk_account_id}, #{account_id}"
    #                 response = get_campaigns(account_id)
    #                 if response.class == Hash && response.key?('data') && response["data"] != nil
    #                     data = save_campaigns(response["data"], account_id, fk_account_id)
    #                     # p "================================>>>>>>>>>> campign count = #{response["data"].size}"
    #                 end
    #                 # p "ending for #{fk_account_id}, #{account_id}"
    #             end
    #         end 
    #         render json:{status: 200}
    #     rescue StandardError => error
    #         # p "=========>", error
    #         render json:{status: 400}
    #     end
    # end

    def ingest_all_accounts
        begin
            IngestFbAccountsJob.perform_async
            render json:{
                status: 200, 
                message: "Job queued to fetch accounts"
            }
        rescue StandardError => error
            # p "=========>", error
            render json: {
                status: 400, 
                message: "failed to queue job to fetch accounts"
            }
        end
    end

    def ingest_all_campaigns
        begin
            IngestFbCampaignsJob.perform_async
            render json:{
                status: 200, 
                message: "Job queued to fetch campaigns"
            }
        rescue StandardError => error
            # p "=========>", error
            render json: {
                status: 400, 
                message: "failed to queue job to fetch campaigns"
            }
        end
    end

    def ingest_all_adsets
        begin
            IngestFbAdsetsJob.perform_async
            render json:{
                status: 200, 
                message: "Job queued to fetch adsets"
            }
        rescue StandardError => error
            # p "=========>", error
            render json: {
                status: 400, 
                message: "failed to queue job to fetch adsets"
            }
        end
    end
    
    def ingest_all_ads
        begin
            IngestFbAdsJob.perform_async
            render json:{
                status: 200, 
                message: "Job queued to fetch ads"
            }
        rescue StandardError => error
            # p "=========>", error
            render json: {
                status: 400, 
                message: "failed to queue job to fetch ads"
            }
        end
    end
end
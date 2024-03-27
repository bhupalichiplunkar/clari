require_relative '../../lib/facebook_module'
 
 class FacebookController < ApplicationController
    include FacebookModule

    def process_and_send_result(response)
        if response.class == Hash && response.has_key?('data') && response["data"] != nil
            result = {status: 200}.merge(response)
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
        process_and_send_result(response)
    end

    def fetch_campaigns
        account_id = params[:account_id]
        response = get_campaigns(account_id)
        process_and_send_result(response) 
    end

    
    def fetch_adsets
        campaign_id = params[:campaign_id]
        response = get_adsets(campaign_id)
        process_and_send_result(response)
    end


    def fetch_ads
         adset_id = params[:adset_id]
         response = get_ads(adset_id)
         process_and_send_result(response)
        
    end

    def fetch_metrics
        level = params[:level]
        id = params[:id]
        response = get_metrics(level, id)
        process_and_send_result(response)
    end
end
require_relative '../../lib/facebook_module'
 
 class FacebookController < ApplicationController
    include FacebookModule

    def save_accounts(accounts_data)
        begin
            accounts_data.each do |acc|
                Account.find_or_create_by(fb_account_id: acc["account_id"]) do |account|
                    account.fb_account_string = acc["id"]
                    account.account_name = acc["name"]
                end
                # campaigns = get_campaigns(acc["account_id"])
            end
        rescue
            puts " Something went wrong in saving account"
        end
    end

    def save_campaigns(campaigns_data, id)
        begin
            fk_account_id = Account.where("fb_account_string = '#{id}'").pluck(:id).first
            campaigns_data.each do |cam|
                Campaign.find_or_create_by(fb_campaign_id: cam["id"]) do |campaign|
                    campaign.campaign_name = cam["name"]
                    campaign.campaign_objective = cam["objective"]
                    campaign.start_date = cam["start_time"]
                    campaign.daily_budget = cam["daily_budget"]
                    campaign.lifetime_budget = cam["lifetime_budget"]
                    campaign.buying_type = cam["buying_type"]
                    campaign.account_id = fk_account_id
                end
                # get_adsets(acc["account_id"])
            end
        rescue
            puts " Something went wrong in saving campaigns"
        end
    end

    def save_adsets(adsets_data, id)
        begin
            fk_campaign_id = Campaign.where("fb_campaign_id = '#{id}'").pluck(:id).first
            p fk_campaign_id
            adsets_data.each do |adst|
                p adst
                Adset.find_or_create_by(fb_adset_id: adst["id"]) do |adset|
                    p adset
                    adset.adset_name = adst["name"]
                    adset.optimization_goal = adst["optimization_goal"]
                    adset.start_date = adst["start_date"]
                    adset.daily_budget = adst["daily_budget"]
                    adset.lifetime_budget = adst["lifetime_budget"]
                    adset.billing_event = adst["billing_event"]
                    adset.bid_strategy = adst["bid_strategy"]
                    adset.campaign_id = fk_campaign_id
                end
                # get_adsets(acc["account_id"])
            end
        rescue
            puts " Something went wrong in saving adsets"
        end
    end
    
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
            return response
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
end
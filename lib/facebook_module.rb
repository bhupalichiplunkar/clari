require 'uri'
require 'net/http'
require "json"

module FacebookModule
    GRAPH_API_BASE_URL = "https://graph.facebook.com/v19.0"
    FB_TOKEN = "EAAKDX99BZAz4BO8ffukd0RStBQCDLETZBXpSg1gU3JZBhZCEcS7zpn00WsePn6PwyrPfHdN5Iktk3stmfJgLhz9NI5s0VZCwvrFSzom7i6r9tQKWB3hSEAMPoZAtZB7do2nw2UzwpfkZCoxMAHM6hiLRpUFXWYISSXZAd5fi9KvaSZA3BkmZAbgEOUFM0VdUOj8CTBz"
    TIME_RANGE =  "{'since':'2024-01-21','until':'2024-03-23'}"
    LIMIT = 10000

    def get_accounts
        begin
            uri = URI("#{GRAPH_API_BASE_URL}/me/adaccounts")
            params = { :access_token => FB_TOKEN, :fields => "account_id,id,name" }
            uri.query = URI.encode_www_form(params)
            res = Net::HTTP.get_response(uri)
            if res.is_a?(Net::HTTPSuccess)
                response = JSON.parse(res.body)
                return response
            else
                return res.body
            end 
        rescue 
            return "Something went wrong while fetching accounts"
        end
    end

    def get_campaigns(account_id, after=nil)
        begin
            fields = "name, objective,start_time,lifetime_budget,daily_budget,buying_type"

            uri = URI("#{GRAPH_API_BASE_URL}/#{account_id}/campaigns")

            params = { :access_token => FB_TOKEN, :fields => fields, :time_range => TIME_RANGE, :limit => LIMIT }

            uri.query = URI.encode_www_form(params)

            res = Net::HTTP.get_response(uri)

            if res.is_a?(Net::HTTPSuccess)
                response = JSON.parse(res.body)
                return response
            else
                return res.body
            end 
        rescue 
            return "Something went wrong while fetching campaigns"
        end
    end

    def get_adsets(campaign_id, after=nil)
        begin
            fields = "name,optimization_goal,start_time,lifetime_budget,daily_budget, buying_type, billing_event, bid_strategy,adset_id"

            uri = URI("#{GRAPH_API_BASE_URL}/#{campaign_id}/adsets")

            params = { :access_token => FB_TOKEN, :fields => fields, :time_range => TIME_RANGE, :limit => LIMIT }

            uri.query = URI.encode_www_form(params)

            res = Net::HTTP.get_response(uri)

            if res.is_a?(Net::HTTPSuccess)
                response = JSON.parse(res.body)
                return response
            else
                return res.body
            end 
        rescue 
            return "Something went wrong while fetching adsets"
        end
    end

    def get_ads(adset_id, after=nil)
        begin
            fields = "name,creative{id,object_type,object_url,object_story_id,facebook_branded_content,instagram_permalink_url,object_story_spec},start_date"

            uri = URI("#{GRAPH_API_BASE_URL}/#{adset_id}/ads")

            params = { :access_token => FB_TOKEN, :fields => fields, :time_range => TIME_RANGE, :limit => LIMIT }

            uri.query = URI.encode_www_form(params)

            res = Net::HTTP.get_response(uri)

            if res.is_a?(Net::HTTPSuccess)
                response = JSON.parse(res.body)
                return response
            else
                return res.body
            end 
        rescue 
            return "Something went wrong while fetching ads"
        end
    end

    def get_metrics(level, id, after=nil)
        begin
            fields = "clicks,campaign_id, campaign_name, date_start, ctr, inline_link_clicks, inline_link_click_ctr, cost_per_unique_inline_link_click, impressions, spend, full_view_impressions, conversions"
            time_increment = 1
            summary = "action_values"

            uri = URI("#{GRAPH_API_BASE_URL}/#{id}/insights")

            params = { :access_token => FB_TOKEN, :fields => fields, :time_range => TIME_RANGE, :limit => LIMIT, :time_increment => time_increment, :summary => summary, :level => level, :after => after }

            uri.query = URI.encode_www_form(params)

            res = Net::HTTP.get_response(uri)

            if res.is_a?(Net::HTTPSuccess)
                response = JSON.parse(res.body)
                return response
            else
                return res.body
            end 
        rescue 
            return "Something went wrong while fetching metrics for #{level}, #{id}, page after #{after}"
        end
    end

    def get_landing_pages(ad_data)
        begin
            creative = ad_data["creative"]
            if creative.key?("object_url")
                creative["object_url"]
            end
        rescue => e
            p e
        end
    end

    def get_ad_type(ad_data)
        begin
            link_data = ad_data["creative"]["object_story_spec"]["link_data"]

            if(link_data && link_data.key?("child_attachments") && link_data["child_attachments"].size > 1)
                return "CAROUSEL"
            else
                return "REGULAR"
            end
        rescue
            return "regular"
        end
    end

    def get_ad_format(ad_data)
        creative = ad_data["creative"]
        ad_data["creative"]["object_type"]
    end

    def get_facebook_url(ad_data)
        ad_data["creative"]["object_story_id"] 
    end

    def get_instagram_url(ad_data)
        ad_data["creative"]["instagram_permalink_url"]
    end

    def fetch_all_accounts
        response = get_accounts
        if response.class == Hash && response.has_key?('data') && response["data"] != nil
            data = save_accounts(response["data"])
            p "Successfully fetched account"
        else
            p "Failed to fetch accounts"
        end
    end

    def save_accounts(accounts_data)
        begin
            response = get_accounts
            accounts_data.each do |acc|
                Account.find_or_create_by(fb_account_id: acc["account_id"]) do |account|
                    account.fb_account_string = acc["id"]
                    account.account_name = acc["name"]
                end
            end
        rescue
            puts " Something went wrong in saving account"
        end
    end

    def save_campaigns(campaigns_data, id, fk = nil)
        begin
            fk_account_id = fk == nil ? Account.where("fb_account_string = '#{id}'").pluck(:id).first : fk
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
        rescue StandardError => e
            puts e, " Something went wrong in saving campaigns"
        end
    end

    def save_adsets(adsets_data, id, fk = nil)
        begin
            fk_campaign_id = fk == nil ? Campaign.where("fb_campaign_id = '#{id}'").pluck(:id).first : fk
            adsets_data.each do |adst|
                Adset.find_or_create_by(fb_adset_id: adst["id"]) do |adset|
                    adset.adset_name = adst["name"]
                    adset.optimization_goal = adst["optimization_goal"]
                    adset.start_date = adst["start_date"]
                    adset.daily_budget = adst["daily_budget"]
                    adset.lifetime_budget = adst["lifetime_budget"]
                    adset.billing_event = adst["billing_event"]
                    adset.bid_strategy = adst["bid_strategy"]
                    adset.campaign_id = fk_campaign_id
                end
            end
        rescue StandardError => error
            p "=========>", error
            puts " Something went wrong in saving adsets"
        end
    end

    def save_ads(ads_data, id, fk = nil)
        begin
            fk_adset_id = (fk == nil) ? (Adset.where("fb_adset_id = #{id.to_i}").pluck(:id).first) : fk
            ads_data.each do |a|
                Ad.find_or_create_by(fb_ad_id: a["id"]) do |ad|
                    p ad
                    ad.ad_name = a["name"]
                    ad.landing_page = get_landing_pages(a)
                    ad.ad_type = get_ad_type(a)
                    ad.ad_format = get_ad_format(a)
                    ad.start_date = a["start_date"]
                    ad.facebook_post = get_facebook_url(a)
                    ad.instagram_post = get_instagram_url(a)
                    ad.adset_id = fk_adset_id
                end
            end
        rescue StandardError => e
            p e
            puts " Something went wrong in saving ads", e
        end
    end

    def fetch_all_campaigns
        begin
            Account.in_batches.each do |accounts|
                accounts.each do |account|
                    account_id = account["fb_account_string"]
                    fk_account_id = account["id"]
                    # p "starting for #{fk_account_id}, #{account_id}"
                    response = get_campaigns(account_id)
                    if response.class == Hash && response.key?('data') && response["data"] != nil
                        data = save_campaigns(response["data"], account_id, fk_account_id)
                        # p "================================>>>>>>>>>> campign count = #{response["data"].size}"
                    else 
                        # p "No campaigns for #{account_id}"
                    end
                    # p "ending for #{fk_account_id}, #{account_id}"
                end
            end 
            # p "Successfully fetched campaigns"
        rescue StandardError => error
            p "=========>", error
            # p "Failed to fetched campaigns"
        end
    end

    def fetch_all_adsets
        begin
            Campaign.in_batches.each do |campaigns|
                campaigns.each do |campaign|
                    campaign_id = campaign["fb_campaign_id"]
                    fk_campaign_id = campaign["id"]
                    # p "starting for #{fk_campaign_id}, #{campaign_id}"
                    response = get_adsets(campaign_id)
                    if response.class == Hash && response.key?('data') && response["data"] != nil
                        data = save_adsets(response["data"], campaign_id, fk_campaign_id)
                        # p "================================>>>>>>>>>> adset count = #{response["data"].size}"
                    else
                        # p "No adsets in campaign #{campaign_id}" 
                    end
                    # p "ending for #{fk_campaign_id}, #{campaign_id}"
                end
            end 
            # p "Successfully fetched adsets"
        rescue StandardError => error
            p "=========>", error
            # p "Failed to fetch adsets"
        end
    end

    def fetch_all_ads
        begin
            Adset.in_batches.each do |adsets|
                adsets.each do |adset|
                    adset_id = adset["fb_adset_id"]
                    fk_adset_id = adset["id"]
                    p "starting for #{fk_adset_id}, #{adset_id}"
                    response = get_ads(adset_id)
                    if response.class == Hash && response.key?('data') && response["data"] != nil
                        data = save_ads(response["data"], adset_id, fk_adset_id)
                        p "================================>>>>>>>>>> ads count = #{response["data"].size}"
                    else
                        p "No ads in adset #{adset_id}" 
                    end
                    p "ending for #{fk_adset_id}, #{adset_id}"
                end
            end 
            p "Successfully fetched ads"
        rescue StandardError => error
            p "=========>", error
            p "Failed to fetch ads"
        end
    end
end
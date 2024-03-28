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
            fields = "name,creative{id,object_type,object_url, facebook_branded_content,instagram_permalink_url,object_story_spec},date_start"

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

end
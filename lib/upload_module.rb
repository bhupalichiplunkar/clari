require 'csv'

module UploadModule
    def upload_csv_file(csv_file)
        CSV.foreach(csv_file, headers: true) do |row|
            adset_name = row['AdSet Name']
            campaign_name = row['Campaign Name']
            ad_name = row['Ad Name']
            date = row['Date']
            date = date.to_date
            revenue = row['Revenue']
    
            metric = nil
            campaigns = nil
            adsets = nil
            ads = nil
          
            if campaign_name
              campaigns = Campaign.where(campaign_name: campaign_name).pluck(:id)
            end
            
            # p "=====> Campaign", campaigns,campaign_ids, campaign_fb_ids
    

    
            if campaigns && campaigns.size > 0 && adset_name
              adsets = Adset.where(campaign_id: campaigns, adset_name: adset_name).pluck(:id)
            elsif adset_name
              adsets = Adset.where(adset_name: adset_name).pluck(:id)
            end
    
    
            # p "=====> Adsets", adsets,adset_ids, adset_fb_ids
    
            if adsets && adsets.size > 0 && ad_name
              ads = Ad.where(adset_id: adsets, ad_name: ad_name).pluck(:id)
            elsif ad_name
              ads = Ad.where(ad_name: ad_name).pluck(:id)
            end
    
    
            ## if only campaign
            if campaigns && !(adsets && ads)
              metric = Metric.find_by("campaign_id IN (?) AND DATE(attr_date) = ?", campaigns, date)
            end
    
            ## if only adset
            if adsets && !(campaigns && ads)
              metric = Metric.find_by("adset_id IN (?) AND DATE(attr_date) = ?", adsets, date)
            end 
    
            ## if only ad
            if ads && !(campaigns && adsets)
              metric = Metric.find_by("ad_id IN (?) AND DATE(attr_date) = ?", ads, date)
            end 
    
            ## if adset & campaign without ad
            if campaigns && adsets && !ads
              metric = Metric.find_by("adset_id IN (?) AND DATE(attr_date) = ?", adsets, date)
            end 
    
            ## if adset & ad without campaign
    
            if ads && adsets
              metric = Metric.find_by("ad_id IN (?) AND DATE(attr_date) = ?", ads, date)
            end
    
            # p "=============>", metric, revenue, date, date.to_s
    
            if(!metric.nil?)
              metric.revenue = revenue
              metric.save
              p "saved", metric
            else 
              p "Didnt find entry for #{date}", ads, adsets, campaigns
            end
        end
    end
end

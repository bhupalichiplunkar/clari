export const ACCOUNT_COLUMNS = [
  {
    title: "Id",
    dataIndex: "id",
    key: "id",
  },
  {
    title: "Name",
    dataIndex: "account_name",
    key: "account_name",
  },
  {
    title: "FB:Account_id",
    dataIndex: "fb_account_string",
    key: "fb_account_string",
  },
];

export const CAMPAIGN_COLUMNS = [
  {
    title: "Id",
    dataIndex: "id",
    key: "id",
  },
  {
    title: "Name",
    dataIndex: "campaign_name",
    key: "campaign_name",
  },
  {
    title: "FB:Campaign_id",
    dataIndex: "fb_campaign_id",
    key: "fb_campaign_id",
  },
  {
    title: "Objective",
    dataIndex: "campaign_objective",
    key: "campaign_objective",
  },
  {
    title: "Start Date",
    dataIndex: "start_date",
    key: "start_date",
  },
  {
    title: "Daily Budget",
    dataIndex: "daily_budget",
    key: "daily_budget",
  },
  {
    title: "Lifetime Budget",
    dataIndex: "lifetime_budget",
    key: "lifetime_budget",
  },
  {
    title: "Buying Type",
    dataIndex: "buying_type",
    key: "buying_type",
  },
];

export const ADSET_COLUMNS = [
  {
    title: "Id",
    dataIndex: "id",
    key: "id",
  },
  {
    title: "Name",
    dataIndex: "adset_name",
    key: "adset_name",
  },
  {
    title: "FB: Adset_id",
    dataIndex: "fb_adset_id",
    key: "fb_adset_id",
  },
  {
    title: "Goal",
    dataIndex: "optimization_goal",
    key: "optimization_goal",
  },
  {
    title: "Start Date",
    dataIndex: "start_date",
    key: "start_date",
  },
  {
    title: "Daily Budget",
    dataIndex: "daily_budget",
    key: "daily_budget",
  },
  {
    title: "Lifetime Budget",
    dataIndex: "lifetime_budget",
    key: "lifetime_budget",
  },
  {
    title: "Billing Event",
    dataIndex: "billing_event",
    key: "billing_event",
  },
];

export const ADS_COLUMNS = [
  {
    title: "Id",
    dataIndex: "id",
    key: "id",
  },
  {
    title: "Name",
    dataIndex: "ad_name",
    key: "ad_name",
  },
  {
    title: "FB: Ad_id",
    dataIndex: "fb_ad_id",
    key: "fb_ad_id",
  },
  {
    title: "Landing page",
    dataIndex: "landing_page",
    key: "landing_page",
  },
  {
    title: "Start Date",
    dataIndex: "start_date",
    key: "start_date",
  },
  {
    title: "Ad Type",
    dataIndex: "ad_type",
    key: "ad_type",
  },
  {
    title: "Ad Format",
    dataIndex: "ad_format",
    key: "ad_format",
  },
  {
    title: "Facebook post",
    dataIndex: "facebook_post",
    key: "facebook_post",
  },
  {
    title: "Instagram post",
    dataIndex: "instagram_post",
    key: "instagram_post",
  },
];

export const TABLE_COLUMN = {
  accounts: ACCOUNT_COLUMNS,
  campaigns: CAMPAIGN_COLUMNS,
  adsets: ADSET_COLUMNS,
  ads: ADS_COLUMNS,
};

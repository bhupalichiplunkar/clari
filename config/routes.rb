require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # mount Sidekiq::Web in your Rails app
  mount Sidekiq::Web => "/sidekiq"

  resource :sessions, only: [:create]

  resources :registrations, only: [:create]

  resources :accounts, only: [:index]

  resources :campaigns, only: [:index]

  resources :adsets, only: [:index]

  resources :ads, only: [:index]

  delete :logout, to: "sessions#logout"

  get :logged_in, to: "sessions#logged_in"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "fetch-accounts", to: "facebook#fetch_accounts"

  get "ingest-accounts", to: "facebook#ingest_all_accounts"

  # get "fetch-account-wise-campaigns", to: "facebook#fetch_campaigns_for_all_accounts"
  
  get "fetch_campaigns/:account_id", to: "facebook#fetch_campaigns"

  get "ingest-campaigns", to: "facebook#ingest_all_campaigns"

  # get "fetch-campaign-wise-adsets", to: "facebook#fetch_adsets_for_all_campaigns"

  get "fetch_adsets/:campaign_id", to: "facebook#fetch_adsets"

  get "ingest-adsets", to: "facebook#ingest_all_adsets"

  get "fetch_ads/:adset_id", to: "facebook#fetch_ads"

  get "ingest-ads", to: "facebook#ingest_all_ads"

  get "fetch_metrics/:level/:id", to: "facebook#fetch_metrics"

  get '*path',
      to: 'fallback#index',
      constraints: ->(req) { !req.xhr? && req.format.html? }

  # Defines the root path route ("/")
  # root "posts#index"
end

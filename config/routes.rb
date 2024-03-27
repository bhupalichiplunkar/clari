Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :sessions, only: [:create]

  resources :registrations, only: [:create]

  delete :logout, to: "sessions#logout"

  get :logged_in, to: "sessions#logged_in"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "fetch-accounts", to: "facebook#fetch_accounts"

  get "fetch_campaigns/:account_id", to: "facebook#fetch_campaigns"

  get "fetch_adsets/:campaign_id", to: "facebook#fetch_adsets"

  get "fetch_ads/:adset_id", to: "facebook#fetch_ads"

  get "fetch_metrics/:level/:id", to: "facebook#fetch_metrics"

  get '*path',
      to: 'fallback#index',
      constraints: ->(req) { !req.xhr? && req.format.html? }

  # Defines the root path route ("/")
  # root "posts#index"
end

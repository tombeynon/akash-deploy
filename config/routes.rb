Rails.application.routes.draw do
  root to: 'dashboard#show'
  resource :keyring, only: %i[destroy]
  resource :password, only: %i[new create destroy]
  resource :wallet, only: %i[show new create destroy]
  resource :certificate, only: %i[new create destroy]
  get '/market', to: 'tickers#akash', as: 'market'
  get '/transfer', to: 'keplr#transfer', as: 'transfer'
  resources :deployments do
    resources :funds, only: [:new, :create]
    resources :bids, only: [:index]
    resources :leases do
      resource :logs, only: [:show]
    end
  end
end

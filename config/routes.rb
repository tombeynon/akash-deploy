Rails.application.routes.draw do
  root to: 'dashboard#show'
  resource :wallet, only: [:show, :new, :create]
  resource :certificate, only: [:new, :create, :destroy]
  resources :deployments do
    resources :bids, only: [:index]
    resources :leases
  end
end

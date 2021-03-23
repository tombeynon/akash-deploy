Rails.application.routes.draw do
  root to: 'dashboard#show'
  resource :wallet, only: [:show, :new, :create]
  resources :deployments do
    resources :leases
  end
end

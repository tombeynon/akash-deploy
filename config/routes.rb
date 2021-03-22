Rails.application.routes.draw do
  root to: 'dashboard#show'
  resource :wallet, only: [:show, :new, :create]
end

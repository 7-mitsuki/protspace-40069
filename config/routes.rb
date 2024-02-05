Rails.application.routes.draw do
  devise_for :users
  root to: 'prototypes#index'
  resources :users, only: %i[show]
  resources :prototypes do 
    resources :comments, only: %i[create]
  end
end

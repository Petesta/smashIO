Smashio::Application.routes.draw do
  get "static/main"
  resources :users
  resources :videos, only: [:new, :create, :index]

  root :to => 'users#index'
  #root :to => 'static#main'

  resources :sessions, only: [:new, :create, :destroy]
  get   'login' => 'sessions#new', as: 'login'
  post  'login' => 'sessions#create'
  get   'logout' => 'sessions#destroy', as: 'logout'
end

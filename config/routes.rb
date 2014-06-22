Smashio::Application.routes.draw do
  resources :users
  resources :videos, only: [:new, :create, :index]

  root :to => 'users#index'

  resources :sessions, only: [:new, :create, :destroy]
  get   'login' => 'sessions#new', as: 'login'
  post  'login' => 'sessions#create'
  get   'logout' => 'sessions#destroy', as: 'logout'
end

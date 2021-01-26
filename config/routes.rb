Rails.application.routes.draw do
 
  resources :friendships
  resources :friend_requests
  root 'posts#index'

  devise_for :users
  resources :friend_requests, only:[:index, :create, :update, :destroy]
  
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

end

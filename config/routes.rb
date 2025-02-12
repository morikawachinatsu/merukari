Rails.application.routes.draw do
  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  
  get 'hello/index' => 'hello#index'
  get 'hello/link' => 'hello#link'
  

  devise_for :users
  resources :users, only: [:show]
  


  
  get 'items/new' => 'items#new'
  

  resources :items do
    post :upload_image, on: :collection
    resources :favorites, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :edit, :update]
  end
  

  root "items#index"
end

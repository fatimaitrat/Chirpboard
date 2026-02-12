Rails.application.routes.draw do
  # get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  #get "api/posts", to: "posts_api#index"
  #API version 1 routes
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      #this creares /api/v1/posts
      resources :posts, only: [:index, :create, :destroy]
      resources :users, only: [:create] do
        member do
          post :follow
          delete :unfollow
        end
      end

    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  delete "/user/avatar", to: "users#destroy_avatar", as: "destroy_user_avatar"
  get "/signup", to: "users#new"

  get "/u/:username", to: "users#show", as: :user_profile

  resources :users, only: [ :create, :edit, :update, :destroy ]
  resources :follows, only: [ :create, :destroy ]

  resources :posts, only: [ :new, :create, :destroy ]
end

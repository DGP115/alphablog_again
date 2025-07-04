Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "pages#home"
  get "about", to: "pages#about"

  # CRUD Routes for Posts done the long way
  #  The All Posts route
  # get "/posts", to: "posts#index"
  # #  Route to show a specific post
  # get "/posts/:id", to: "posts#show", as: "post"
  # get "/posts/new", to: "posts#new", as: "new_post"
  # #  Note:  The post verb happens when saving a new post, which would be done
  # #         in the form initated nu a "new" function.  So, the only difference is
  # #         the "post" verb
  # post "/posts", to: "posts#create"
  # #  Edit post route
  # get "/posts/:id/edit", to: "posts#edit", as: "edit_post"
  # #  Update post route
  # patch "/posts/:id", to: "posts#update"
  # #  Delete post path
  # delete "/posts/:id", to: "posts#destroy"
  # The short way:  NOTE:  The class name is pluralized
  resources :posts do
    resources :comments, only: %i[ create edit update destroy ]
  end

  # Users
  # 1. Want the signup route to be /signup
  get "signup", to: "users#new"
  resources :users, except: %i[ new ]
  # Login management
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  # Tried using delete "logout", to: "sessions#destroy" but Rails complained that no Get route was defined
  get "logout", to: "sessions#destroy"

  # Categories
  resources :categories

  # Search
  get "search", to: "search#index"
  get "clear", to: "search#clear"

  # Notifications
  resources :notifications, only: %i[ destroy ] do
    delete "destroy", to: "notifications#destroy", on: :member
    collection do
      delete "destroy_all_read", to: "notifications#destroy_all_read"
      delete "destroy_all_unread", to: "notifications#destroy_all_unread"
    end
  end
end

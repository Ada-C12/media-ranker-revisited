Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepages#index'
  
  resources :works
  resources :users
  #resources :votes
  
  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  # post "/logout", to: "users#logout", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"
  
  post "/vote/:work_id", to: "votes#create", as: "vote"
  
  delete "/logout", to: "users#destroy", as: "logout"
  
  get "/auth/github", as: "github_login", as: 'github_login'
  #get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  get "/auth/github/callback", to: "users#create", as: "auth_callback"
end

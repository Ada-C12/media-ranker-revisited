Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "works#root"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"
  delete "/logout", to: "users#destroy", as: "logout"

  
  resources :works
  resources :users, only: [:index, :show]
end

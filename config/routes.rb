Rails.application.routes.draw do
  root "works#root"
  
  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"
  
  resources :users, only: [:index, :show]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "works#root"

  get "/auth/github", as: "github_login"

  get "/auth/:provider/callback", to: "users#create"

  delete "/logout", to: "users#destroy", as: "logout"

  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"

  resources :users, only: [:index, :show]
end

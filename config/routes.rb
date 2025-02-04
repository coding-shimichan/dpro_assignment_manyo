Rails.application.routes.draw do
  root to: redirect("/tasks")

  resources :users, except: [:index]
  get "/users", to: redirect("/tasks")

  namespace :admin do
    resources :users
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

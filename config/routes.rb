Rails.application.routes.draw do
  root to: redirect("/tasks")

  resources :users, except: [:index]

  namespace :admin do
    resources :users
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  resources :labels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

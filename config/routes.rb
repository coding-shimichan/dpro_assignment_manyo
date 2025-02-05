Rails.application.routes.draw do
  root to: "sessions#new", as: :public_root, constraints: lambda {|request| request.session[:user_id].present? == false}
  root to: "tasks#index", constraints: lambda {|request| request.session[:user_id].present? }

  resources :users, except: [:index]

  namespace :admin do
    resources :users
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  resources :labels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

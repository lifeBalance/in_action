Rails.application.routes.draw do
  namespace :admin do
  get 'application/index'
  end

  devise_for :users

  root 'projects#index'

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets
  end

  namespace :admin do
    root 'application#index'

    resources :projects, only: [:new, :create, :destroy]
  end
end

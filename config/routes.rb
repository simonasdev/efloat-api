require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.production?
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  else
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, skip: :registrations
  resources :users

  resources :devices do
    collection do
      get :connected
      post :mass_command
      post :mass_state_change
      post :import
    end
    member do
      post :command
      get :watch, as: :watch_race
    end

    resources :data_lines, only: :index
  end

  resources :races do
    member do
      post :import_tracks
      post :import_limited_tracks
      post :import_markers
      get :watch
      get 'watch/:device_id', action: :device, as: :watch_device
      get :speed_report
    end
  end

  resources :tickets, only: [:index] do
    post :import, on: :collection
    put :pass, on: :collection
  end

  namespace :api, defaults: { format: :json } do
    resources :races, only: :index
    resources :devices, only: :index
  end

  root to: "races#index"
end

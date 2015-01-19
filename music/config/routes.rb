Rails.application.routes.draw do

  resources :users, only: [:index, :create, :new ] do
    member do
      get :show
    end
  end
  resource :session, only: [:create,:new,:destroy]

  resources :bands do
      resources :albums, only: :new
  end

  resources :albums, except: [:new, :index] do
    resources :tracks, only: :new
  end

  resources :tracks, except: [:new, :index] do
    resources :notes, only: [:new, :destroy]
  end


end

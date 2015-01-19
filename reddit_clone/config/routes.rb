Rails.application.routes.draw do
  resources :users, only: [:create, :new]
  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: [:destroy]

  resources :posts, except: [:index, :destroy] do
    resources :comments, only: [:new, :show]
  end

  resources :comments, only: [:create, :destroy]
end

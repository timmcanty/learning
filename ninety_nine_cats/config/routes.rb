Ninetyninecats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      post :approve
      post :deny
    end
  end

  resources :users, only: [:new, :create]
  resource :sessions, only: [:new, :create, :destroy]

end

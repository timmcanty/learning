Contacts::Application.routes.draw do
  resources :users, only: [:index, :create, :update, :destroy, :show] do
    member do
      get 'favorites'
    end

    resources :contacts, only: [:index] do
      member do
        post 'favorite'
      end
    end

    resources :contact_shares, only: [] do
      member do
        post 'favorite'
      end
    end

    resources :comments, has_many: :comments, only: [:index]
  end
  resources :contacts, only: [:create, :update, :destroy, :show] do
    resources :comments, has_many: :comments, only: [:index]
  end

  resources :contact_shares, only: [:create,  :destroy] do
    resources :comments, has_many: :comments, only: [:index]
  end


end

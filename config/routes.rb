Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  as :user do
    get 'signin' => 'static_pages#root', as: :new_user_session
    delete 'signout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :journals, only: [:index] do
    collection do
      post :sync
    end
    member do
      post :push_category
    end
  end

  resources :teams, only: [:index]
  resources :authors, only: [:index, :update]

  resource :teamwork_api_key, only: [:new, :create, :edit, :update]

  root to: 'static_pages#root'
end

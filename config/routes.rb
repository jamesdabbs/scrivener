Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  as :user do
    get 'signin' => 'static_pages#root', as: :new_user_session
    delete 'signout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: 'static_pages#root'
end

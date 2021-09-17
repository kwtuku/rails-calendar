Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}
  devise_scope :user do
    get 'users/confirm_destroy', to: 'users/registrations#confirm_destroy'
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  get 'users', to: 'home#index'

  resources :events, only: %i(index show create edit update destroy) do
    member do
      get 'duplicate'
    end
  end

  root to: 'home#index'
end

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}
  devise_scope :user do
    get 'users/confirm_destroy', to: 'users/registrations#confirm_destroy'
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  get 'users', to: 'home#index'
  root to: 'home#index'
end

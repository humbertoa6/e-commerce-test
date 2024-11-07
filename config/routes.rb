Rails.application.routes.draw do
  get 'cart/show'
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :coupons, only: [:index, :new, :create, :edit, :update, :destroy]
  post 'redeem_coupon', to: 'coupons#redeem', as: 'redeem_coupon'
  get 'cart', to: 'cart#show'
  root 'home#index'
  post 'complete_purchase/:id', to: 'cart#complete', as: 'complete_purchase'
  get 'purchase_confirmation/:id', to: 'cart#confirmation', as: 'purchase_confirmation'
  resources :user_coupons, only: [:edit, :update, :destroy]
end

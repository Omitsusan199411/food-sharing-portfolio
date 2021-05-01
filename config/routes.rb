Rails.application.routes.draw do
  devise_for :shops, controllers: {
    sessions: 'shops/sessions',
    passwords: 'shops/passwords',
    registrations: 'shops/registrations',
  }
  get '/shops', to: redirect("/shops/sign_up")

  devise_scope :shop do
    get '/shops', to: redirect("/shops/sign_up")
    get 'shop_details', to: 'shops/registrations#new_shop_detail'
    post 'shop_details', to: 'shops/registrations#create_shop_detail'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get '/users', to: redirect("/users/sign_up")

  devise_scope :user do
    get '/users/password/edit/:id', to: 'users/passwords#edit', as: :edit_user_reset_password
  end

  namespace :v1, defaults: {format: :html} do
    post '/shop/reset_passwords', to: 'shop_reset_passwords#create'
    patch '/shop/reset_passwords/:id', to: 'shop_reset_passwords#update', as: :shop_reset_password
    get '/shop/reset_passwords', to: redirect("/shops/sign_in")
    get '/shop/reset_passwords/:id', to: redirect("/shops/password/edit")
  end

  namespace :v2, defaluts: {format: :html} do
    post '/user/reset_passwords', to: 'user_reset_passwords#create'
    patch '/user/reset_passwords/:id', to: 'user_reset_passwords#update', as: :user_reset_password
    get '/user/reset_passwords', to: redirect("/users/sign_in")
    get '/user/reset_passwords/:id', to: redirect("/users/password/edit")
  end


  namespace :profile_address_registrations do
    get '/user_details/profile', to: 'user_details#new_profile'
    post '/user_details/profile', to: 'user_details#create_profile'
    get '/user_details/address', to: 'user_details#new_address'
    post '/user_details/address', to: 'user_details#create_address'
    get '/user_details/postal_code', to: 'user_details#postal_search'
  end

  namespace :mypage do
    resources :users, only: [:show] do
      get '/detail_updates/profile', to: 'user_detail_updates#new_update_profile'
      patch '/detail_updates/profile', to: 'user_detail_updates#update_profile'
      get '/details_updates/address', to: 'user_detail_updates#new_update_address'
      patch '/details_updates/address', to: 'user_detail_updates#update_address'
      get '/detail_updates/postal_code', to: 'user_detail_updates#postal_confirm_search'
    end
  end
  
  root "products#index"

end

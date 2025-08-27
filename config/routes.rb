Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  authenticated :user do
    root "works#index", as: :authenticated_root
  end

  unauthenticated do
    root "users/sessions#new", as: :unauthenticated_root
  end

  resources :works
end

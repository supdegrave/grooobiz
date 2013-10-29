Grooobiz::Application.routes.draw do
  resources :locations

  resources :categories

  resources :companies

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :users do
      get :revoke_role, :on => :member
  end
end
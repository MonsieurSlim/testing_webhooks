Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users

  resources :projects do
    resources :tickets do
      resources :comments
    end
    resource  :access
    resources :features
    resources :sprints
  end

  get 'github/commit'
  root :to => 'projects#index'
end

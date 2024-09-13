Rails.application.routes.draw do
  resources :posts, only: [:index, :show] do
    resource :likes, only: [:create]
  end

  namespace :admin do
    resources :posts, only: [:create]
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
 
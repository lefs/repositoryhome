Repositoryhome::Application.routes.draw do
  # Users
  devise_for :users
  resources :users

  # Repositories
  resources :repositories

  # Settings
  get    '/settings',               to:  'settings#index'
  put    '/settings',               to:  'settings#update_user_details'
  get    '/settings/keys/new',      to:  'settings#new_key', as: :new_key
  get    '/settings/keys/:id/edit', to:  'settings#edit_key', as: :edit_key
  post   '/settings/keys',          to:  'settings#create_key', as: :keys
  put    '/settings/keys/:id',      to:  'settings#update_key', as: :key
  delete '/settings/keys/:id',      to:  'settings#destroy_key', as: :key

  root to: 'repositories#index'
end

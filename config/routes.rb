Rails.application.routes.draw do
  get '/s/:slug', to: 'links#redirect_by_slug', as: :short
  resources :links
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "links#index"
end

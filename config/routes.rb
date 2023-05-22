require 'sidekiq/web'

Rails.application.routes.draw do
  resources :pizzas
  mount Sidekiq::Web => '/sidekiq'
  root to: 'jobs#home'
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'
  resources :books
  scope :api do
    scope :json_api do
      jsonapi_resources :restaurants
      jsonapi_resources :dishes
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  post 'do_job', to: 'jobs#do_job'
  # Defines the root path route ("/")
  # root "articles#index"
end

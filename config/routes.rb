require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
                                    confirmations: 'confirmations' }

  concern :votable do
    member { post :vote }
    member { post :revote }
  end
  
  resources :questions, concerns: [:votable] do
    resources :comments, only: [:create]
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
      resources :comments, only: [:create]
    end
  end

  resources :attachments, only: :destroy
  resources :awards, only: :index
  resources :subscriptions, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i(new edit) do
        resources :answers, except: %i(new edit), shallow: true
      end
    end
  end

  get '/search', to: 'search#search'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end

Rails.application.routes.draw do
  devise_for :users

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

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end

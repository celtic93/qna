Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member { post :vote }
  end
  
  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :awards, only: :index

  root to: 'questions#index'
end

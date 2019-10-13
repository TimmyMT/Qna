require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_clear
    end
  end

  resources :achievements, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions, shallow: true, concerns: [:votable] do
    resources :comments, module: :questions

    resources :answers, shallow: true, concerns: [:votable] do
      resources :comments, module: :answers

      member do
        patch :select_best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:show, :create, :update, :destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end

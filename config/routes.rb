Rails.application.routes.draw do

  devise_for :users

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
    resources :answers, shallow: true, concerns: [:votable] do
      member do
        patch :select_best
      end
    end
  end

  mount ActionCable.server => '/cable'
end

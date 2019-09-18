Rails.application.routes.draw do

  devise_for :users

  root to: 'questions#index'

  resources :achievements, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        patch :select_best
      end
    end
  end
end

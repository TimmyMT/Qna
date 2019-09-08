Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'



  resources :questions, shallow: true do
    member do
      patch 'select_best_answer/:answer_id', to: 'questions#select_best_answer', as: 'select_best_answer'
    end
    resources :answers, shallow: true
  end
end

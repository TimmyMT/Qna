Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'
  patch 'questions/:id/select_best_answer/:answer_id', to: 'questions#select_best_answer', as: 'select_best_answer'

  resources :questions, shallow: true do
    resources :answers, shallow: true
  end
end

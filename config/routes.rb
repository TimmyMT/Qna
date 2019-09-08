Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'
  get 'questions/:id/select_best_answer/:answer_id', to: 'questions#select_best_answer', as: 'select_best_answer'

  resources :questions do
    resources :answers, shallow: true
  end
end

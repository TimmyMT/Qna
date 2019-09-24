Rails.application.routes.draw do

  devise_for :users

  root to: 'questions#index'

  post 'votes/create/:class_name/:class_name_id/:value', to: 'votes#create', as: 'give_vote'
  delete 'votes/destroy/:votable_id', to: 'votes#destroy', as: 'pick_up_vote'

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

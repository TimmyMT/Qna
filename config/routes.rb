Rails.application.routes.draw do

  devise_for :users

  root to: 'questions#index'

  post 'votes/give_vote/:klass_name/:klass_name_id/:value', to: 'votes#give_vote', as: 'give_vote'
  delete 'votes/pick_up_vote/:votable_id', to: 'votes#pick_up_vote', as: 'pick_up_vote'

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

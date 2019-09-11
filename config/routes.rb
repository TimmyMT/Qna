Rails.application.routes.draw do

  devise_for :users

  root to: 'questions#index'

  get 'delete_attachment/:id', to: 'attachments#delete_attachment', as: 'delete_attachment'

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        patch :select_best
      end
    end
  end
end

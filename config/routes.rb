Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root 'welcome#index'

  get 'welcome/index'

  namespace :api, defaults: { format: :json } do
    resources :questions, only: :index
  end
end

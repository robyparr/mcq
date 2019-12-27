Rails.application.routes.draw do
  root to: 'links#index'

  resources :links do
    member do
      post '/complete', action: :complete
    end
  end

  resources :media_queues, as: :queues, path: 'queues'
end

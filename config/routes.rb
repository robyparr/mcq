Rails.application.routes.draw do
  root to: 'media_items#index'

  resources :media_items do
    member do
      post '/complete', action: :complete
    end
  end

  resources :media_queues, as: :queues, path: 'queues'
end

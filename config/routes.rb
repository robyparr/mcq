Rails.application.routes.draw do
  root to: 'links#index'

  resources :links
  resources :media_queues, as: :queues, path: 'queues'
end

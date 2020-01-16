Rails.application.routes.draw do
  root to: 'media_queues#index'

  resources :media_items, path: 'media' do
    member do
      post '/complete', action: :complete
    end
  end

  resources :media_queues, as: :queues, path: 'queues'

  resources :media_priorities, only: %i[index create]
end

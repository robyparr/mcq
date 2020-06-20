Rails.application.routes.draw do
  root to: 'media_queues#index'

  resources :media_items, path: :media do
    member do
      post '/complete', action: :complete
      post :snooze
    end

    collection do
      put '/bulk_change_queue', action: :bulk_change_queue
      put '/bulk_mark_completed', action: :bulk_mark_completed
      delete '/bulk_destroy', action: :bulk_destroy
    end

    resources :media_notes, as: :notes,
                            path: :notes,
                            only: %i[create update destroy],
                            shallow: true
  end

  resources :media_queues, as: :queues, path: 'queues'
  resources :media_priorities, only: %i[index create]
  resources :integrations, only: %i[index new] do
    collection do
      get :authentication_redirect
      post :synchronize
    end
  end
end

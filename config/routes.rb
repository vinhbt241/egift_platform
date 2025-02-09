# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create] do
        collection do
          get :me
        end
      end

      resources :sessions, only: [:create]

      resources :brands, only: %i[index create update] do
        scope module: 'brands' do
          resources :products, only: %i[index create]
        end
      end

      resources :products, only: %i[show update destroy]

      resources :clients, only: %i[index create update]

      namespace :clients do
        resources :sessions, only: [:create]
        resources :products, only: [:index]
      end

      resources :product_accesses, only: %i[create]
      delete :product_accesses, to: 'product_accesses#destroy'
    end
  end
end

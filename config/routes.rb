Rails.application.routes.draw do
  resources :screeners
  draw :external_urls

  devise_for :users

  root to: "static#index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "/user/status", to: "static#impersonation_status", as: :impersonation_status

  concern :archivable do
    member do
      patch :archive
      patch :unarchive
    end
  end

  concern :copyable do
    member do
      post :copy
    end
  end

  concern :collection_exportable do
    collection do
      get :export_xlsx, action: :collection_export_xlsx
    end
  end

  concern :member_exportable do
    member do
      get :export_xlsx, action: :member_export_xlsx
    end
  end

  concern :importable do
    collection do
      get :upload
      post :import
      get :export_example
    end
  end

  resources :inbound_requests do
    collection do
      post :avails
    end
  end

  namespace :admin do
    root to: 'dashboard#index'

    authenticate :user, lambda { |u| u.admin? } do
      mount Blazer::Engine, at: :blazer
      mount GoodJob::Engine, at: :good_job
      mount MaintenanceTasks::Engine, at: :maintenance_tasks
      mount PgHero::Engine, at: :pghero
    end

    if Rails.env.development?
      authenticate :user, lambda { |u| u.admin? } do
        mount Lookbook::Engine, at: :lookbook
      end
    end

    resources :data_logs, only: [:index, :show], concerns: :collection_exportable

    resources :players, concerns: [:archivable, :copyable, :collection_exportable] do
      member do
        get :profile
      end
    end

    resources :reports, concerns: [:collection_exportable, :member_exportable]
    resources :rosters, concerns: [:archivable, :copyable, :collection_exportable]
    resources :scouting_reports, concerns: [:archivable, :copyable, :collection_exportable, :member_exportable]
    resources :scouts, concerns: [:archivable, :copyable, :collection_exportable]
    resources :stats, concerns: [:archivable, :copyable, :collection_exportable]
    resources :system_groups, concerns: :collection_exportable
    resources :system_groups, concerns: :collection_exportable
    resources :system_permissions, concerns: [:copyable, :collection_exportable]
    resources :system_roles, concerns: :collection_exportable
    resources :teams, concerns: [:archivable, :copyable, :collection_exportable]

    resources :users, concerns: :collection_exportable do
      member do
        post :impersonate
        put :trigger_password_reset_email
      end

      collection do
        post :stop_impersonating
      end
    end
  end
end

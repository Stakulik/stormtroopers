Rails.application.routes.draw do

  match "*any", to: "application#options", via: [:options]

  get "/index", to: "pages#index"

  scope module: "api" do
    namespace :v1 do
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"

      post "/signup", to: "users#create"
      get "/confirmation", to: "users#confirmation"
      post "/forgot_password", to: "users#forgot_password"
      get "/reset_password", to: "users#reset_password"
      post "/update_password", to: "users#update_password"
      delete "/destroy_account", to: "users#destroy"

      resource :users

      resources :planets, :people, :starships, controller: "sw_units" do
        collection do
          get "/search", to: "sw_units#search"
        end
      end
    end
  end
end

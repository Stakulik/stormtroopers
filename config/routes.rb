Rails.application.routes.draw do

  match "*any", to: "application#options", via: [:options]

  get "/index", to: "pages#index"

  scope module: "api" do
    namespace :v1 do
      post "/login", to: "session#create"
      delete "/logout", to: "session#destroy"

      post "/signup", to: "users#create"
      get "/confirmation", to: "users#confirmation"
      get "/resend_confirmation", to: "users#resend_confirmation"
      post "/forgot_password", to: "users#forgot_password"
      get "/reset_password", to: "users#reset_password"
      post "/update_password", to: "users#update_password"
      delete "/destroy_account", to: "users#destroy"


      resources :users, except: [:index] do
        member { get "edit", to: "users:edit" }
      end

      resources :people
      resources :starships
      resources :planets
    end
  end

end

Rails.application.routes.draw do

  match "*any", to: "application#options", via: [:options]

  get "/index", to: "pages#index"

  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"

  scope module: "api" do
    namespace :v1 do
      resource :users do
        collection do
          post "/signup", to: "users#create"
          delete "/destroy_account", to: "users#destroy"
          get "/confirmation", to: "users#confirmation"
          get "/reset_password", to: "users#reset_password"
          post "/update_password", to: "users#update_password"
        end
      end

      resources :people
      resources :starships
      resources :planets
    end
  end

end

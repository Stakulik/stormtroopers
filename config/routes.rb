Rails.application.routes.draw do

  get "/index", to: "pages#index"

  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"

  post "/signup", to: "users#create"
  get "/confirmation", to: "users#confirmation"
  delete "/destroy_account", to: "users#destroy"

  match "*any", to: "application#options", :via => [:options]

  scope module: "api" do
    namespace :v1 do
      resources :users
      resources :people
      resources :starships
      resources :planets
    end
  end

end

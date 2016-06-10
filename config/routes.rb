Rails.application.routes.draw do

  get "/index", to: "pages#index"

  post "/authenticate", to: "auth#authenticate"

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

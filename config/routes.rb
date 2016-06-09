Rails.application.routes.draw do
  match '*any' => 'application#options', :via => [:options]

  scope module: "api" do
    namespace :v1 do 
      resources :people
      resources :starships
      resources :planets
    end
  end

end

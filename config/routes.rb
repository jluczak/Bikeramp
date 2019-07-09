Rails.application.routes.draw do
  resources :trips, except: :new
end

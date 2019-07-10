Rails.application.routes.draw do
  get 'stats/weekly'
  get 'stats/monthly'
  resources :trips, except: :new
end

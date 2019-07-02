Rails.application.routes.draw do
  resources :trips, only: %i[show index create update destroy]
end

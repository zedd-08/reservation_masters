Rails.application.routes.draw do
  devise_for :users
  resources :reservations
  resources :stays, only: %i[ index new show edit create update ]

  put "stays/:id/enable", to: "stays#enable", as: "enable_stay"
  put "stays/:id/disable", to: "stays#disable", as: "disable_stay"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "reservations/:id/receipt", to: "generate_receipts#generate_pdf", as: "generate_receipt"

  # Defines the root path route ("/")
  root "homepage#index"
end

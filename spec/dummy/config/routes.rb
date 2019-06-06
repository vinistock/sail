# Initialize the Rails application.

Rails.application.routes.draw do
  root "application#index"
  mount Sail::Engine => '/sail'
end

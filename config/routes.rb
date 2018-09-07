Sail::Engine.routes.draw do
  resources :settings, only: %i[index update], param: :name
end

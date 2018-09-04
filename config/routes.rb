Sail::Engine.routes.draw do
  resources :settings, only: %i[index]
end

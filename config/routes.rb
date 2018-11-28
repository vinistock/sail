# frozen_string_literal: true

Sail::Engine.routes.draw do
  root "settings#index"
  resources :settings, only: %i[index update show], param: :name
  get "settings/switcher/:positive/:negative/:throttled_by" => "settings#switcher"
end

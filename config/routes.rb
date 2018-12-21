# frozen_string_literal: true

Sail::Engine.routes.draw do
  root "settings#index"

  resources :settings, only: %i[index update show], param: :name do
    member do
      put "reset"
    end
  end

  get "settings/switcher/:positive/:negative/:throttled_by" => "settings#switcher"
end

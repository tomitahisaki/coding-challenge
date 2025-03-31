# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'simulate_plans', to: 'simulate_plans#index' 
    end
  end
end

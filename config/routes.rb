Rails.application.routes.draw do
  devise_for :users
  resources :devices do
    member do
      post :toggle_state
    end
  end
  root to: "devices#index"
end

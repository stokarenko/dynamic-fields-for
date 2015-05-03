Rails.application.routes.draw do
  resources :users do
    member do
      get 'edit_without_fields'
    end
  end
end

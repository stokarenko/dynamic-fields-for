Rails.application.routes.draw do
  resources :email_forms

  resources :users do
    member do
      get 'edit_without_fields'
      get 'edit_with_clean_text'
      get 'events'
    end
  end
end

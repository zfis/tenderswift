Rails.application.routes.draw do
  resources :items
  resources :sections
  resources :pages
  resources :boqs
  resources :participants
  resources :requests
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users do
	  resources :hostels
  end

  resources :hostels do
  	resources :bookings
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
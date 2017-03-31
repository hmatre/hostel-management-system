Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users do
	  resources :hostels
  end

  resources :hostels do
  	resources :bookings
  end

  resources :bookings,  :only => [] do
		patch 'confirm_booking', on: :member
	end

	#patch 'bookings/:id/confirm_booking' , to: "bookings#confirm_booking", as: :update_booking

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

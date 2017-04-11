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
		get 'confirm_booking', on: :member

	end

  resources :users, :only => [] do
    resources :bookings, only: [:index]
  end

  get 'check_booking_availability', to: "bookings#check_booking_availability", as: :check_booking_availability
	
  get 'admin_booking_status', to: "bookings#admin_booking_status"
  get 'booking_checkout', to: "bookings#booking_checkout"
  get 'cancel_url', to: "bookings#cancel_url"
  get 'ipn_url', to: "bookings#ipn_url"
  get 'return_url', to: "bookings#return_url"
  get '/users/:id/subscription_index', to: "bookings#subscription_index", as: :users_subscriptions
  #patch 'bookings/:id/confirm_booking' , to: "bookings#confirm_booking", as: :update_booking

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

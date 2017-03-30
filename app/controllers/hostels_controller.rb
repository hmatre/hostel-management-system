class HostelsController < ApplicationController
	load_and_authorize_resource
	def index
	end

	def new
	end

	def create
		@hostel = current_user.hostels.new(hostel_params)
		@hostel.save
		redirect_to user_hostels_path(current_user)
	end

	def edit
	end

	def update
		@hostel.update(hostel_params)
		redirect_to user_hostels_path(current_user)
	end
	
	def show
		@booked= Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		@hostel.available_rooms=@hostel.no_of_rooms-@booked
	end

	private
	def hostel_params
		params.require(:hostel).permit!
	end
end

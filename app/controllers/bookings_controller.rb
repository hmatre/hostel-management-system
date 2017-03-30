class BookingsController < ApplicationController
	load_and_authorize_resource
	def index
	end

	def new
	end

	def create                     
		@hostel = Hostel.find(params[:hostel_id])
		@booking = @hostel.bookings.new(booking_params)
		@booking.save
		@booked= Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		@hostel.available_rooms=@hostel.no_of_rooms-@booked
	end

	def show
	end

	 private
	 def booking_params
	 	 params.require(:booking).permit(:months, :no_of_rooms).merge({user_id:current_user.id})
	 end
end

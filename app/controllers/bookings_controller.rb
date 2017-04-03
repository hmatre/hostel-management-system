class BookingsController < ApplicationController
	load_and_authorize_resource
	def index
		#@hostel = Hostel.find(params[:hostel_id])
		@booking = current_user.bookings.order(created_at: :desc)
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
		@hostel = Hostel.find(params[:hostel_id])
	end

	def confirm_booking
		@booking = Booking.find(params[:id])
		if @booking.update(confirm: true)
			UserMailer.welcome_booking_email(current_user).deliver
		end
		redirect_to root_path
	end

	 private
	 def booking_params
	 	 params.require(:booking).permit(:months, :no_of_rooms).merge({user_id:current_user.id})
	 end
end

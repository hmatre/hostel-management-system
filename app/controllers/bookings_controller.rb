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
		booking_room = booking_params[:no_of_rooms].to_i
		booked = Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		available_rooms = @hostel.no_of_rooms - booked
		if available_rooms >= booking_room
			@booking.save 
		else
			redirect_to :back, :alert => '* Number of rooms you want to book are not available'
		end
		@booked = Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		@hostel.available_rooms = @hostel.no_of_rooms - @booked
		@hostel.save
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

	def destroy
		hostel= Hostel.find(@booking.hostel_id)
		@booking.destroy
		booked = Booking.where(hostel_id: @booking.hostel_id).sum(:no_of_rooms)
		hostel.available_rooms = hostel.no_of_rooms - booked
		hostel.save
		redirect_to :back
	end

	def check_booking_availability
		@hostel = Hostel.find(params[:hostel_id])
		@booked = Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		@hostel_available_rooms = @hostel.no_of_rooms - @booked
		@Booking_room = params[:no_of_rooms]
		render json: [@hostel_available_rooms,@Booking_room]
	end

	def admin_booking_status
		@hostels = current_user.hostels
		#@user = Hostel.find(id: @hostel).user_id
	end

	private
	
 	def booking_params
 	 params.require(:booking).permit(:start_date, :end_date, :no_of_rooms).merge({user_id:current_user.id})
 	end
end

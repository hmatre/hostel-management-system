class HostelsController < ApplicationController
	load_and_authorize_resource except: [:index]

	def index
		if params[:q].present?
			@q = Hostel.search(name_cont: params[:q][:name])
			# @q = Hostel.search(params[:q])
		else
			@q = Hostel.search(params[:q])
		end
		@hostels = @q.result(distinct: true)
	end

	def new
	end

	def create
		@hostel = current_user.hostels.new(hostel_params)
		debugger
		if @hostel.save
			redirect_to user_hostels_path(current_user)
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @hostel.update(hostel_params)
			redirect_to user_hostels_path(current_user)
		else
			render 'edit'
		end
	end
	
	def show
		@booking= Booking.new
		@booked = Booking.where(hostel_id: @hostel).sum(:no_of_rooms)
		@hostel.available_rooms = @hostel.no_of_rooms - @booked
		# @booking = @hostel.bookings.find_by(user_id: current_user.id)
	end

	private
	def hostel_params
		params.require(:hostel).permit!
	end
end

class BookingsController < ApplicationController
	 load_and_authorize_resource :except => [:subscription_index]
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

	def booking_checkout
		debugger
		hostel = Hostel.find(params[:booking][:hostel_id])
		session[:hostel_id] = hostel.id
		paypal_id = User.find(hostel.user_id).paypal_email
		rooms = params[:booking][:no_of_rooms].to_i
		session[:rooms] = rooms
		start_date = params[:booking][:start_date]
		session[:start_date] = start_date
		end_date = params[:booking][:end_date]
		session[:end_date] = end_date
		amount = hostel.room_rent * rooms
		# @transaction = Transaction.new
		@api = PayPal::SDK::AdaptivePayments.new
		@pay = @api.build_pay({
		  :actionType => "PAY",
		  :cancelUrl => "http://localhost:3000/cancel_url",
		  :currencyCode => "USD",
		  :feesPayer => "SENDER",
		  :ipnNotificationUrl => "http://localhost:3000/ipn_url",
		  :receiverList => {
		    :receiver => [{
		      :amount => amount,
		      :email => "hmatre-facilitator@bestpeers.com" }] },
		  :returnUrl => "http://localhost:3000/return_url" })

		@response = @api.pay(@pay)
		if @response.success? && @response.payment_exec_status != "ERROR"
			debugger
		  @response.payKey
		  session[:booking_paykey] = @response.payKey
		  @transaction = Transaction.new
		  redirect_to @api.payment_url(@response)  # Url to complete payment
		  # redirect_to hostels_path
		else
		  @response.error[0].message
		  redirect_to root_path
		end
	end

	def cancel_url
	end

	def ipn_url
	end

	def return_url
		@api = PayPal::SDK::AdaptivePayments::API.new
		# Build request object
	  @payment_details = @api.build_payment_details({:payKey => session[:booking_paykey] })
	  # Make API call & get response
	  payment_details_response = @api.payment_details(@payment_details)
	  transaction_id = payment_details_response.paymentInfoList.paymentInfo.first.transactionId
	  transaction_status = payment_details_response.paymentInfoList.paymentInfo.first.transactionStatus
		amount = payment_details_response.paymentInfoList.paymentInfo.first.receiver.amount
		receiver_pay_email = payment_details_response.paymentInfoList.paymentInfo.first.receiver.email
		paykey = payment_details_response.payKey
		@sender_pay_email = payment_details_response.sender.email
		
		if transaction_status == "COMPLETED"
			create_booking
		else
			redirect_to root_path, :alert => "* Sorry, due to some network issues transaction not completed"
		end

		create_transaction(amount, receiver_pay_email, owner_id, transaction_status, paykey, transaction_id )
		create_subscription(@transaction.id)
		
		session[:rooms] = nil
		session[:start_date] = nil
		session[:end_date] = nil
		session[:hostel_id] = nil
		session[:booking_paykey] = nil
	end
	
	def create_booking
		@booking = Booking.new({:no_of_rooms => session[:rooms], :start_date => session[:start_date], :end_date => session[:end_date], :user_id => current_user.id, :hostel_id => session[:hostel_id]})
		@booking.save
		
		@hostel = Hostel.find(session[:hostel_id])
		owner_id = @hostel.user_id
		@booked = Booking.where(:hostel_id => session[:hostel_id]).sum(:no_of_rooms)
		@hostel.available_rooms = @hostel.no_of_rooms - @booked
		@hostel.save
	end

	def create_transaction(amount, receiver_pay_email, owner_id, transaction_status, paykey, transaction_id)
		@transaction = Transaction.new({:amount => amount, :user_id => current_user.id, :paypal_email => receiver_pay_email, :owner_id => owner_id, :paypal_status => transaction_status, :paypal_paykey => paykey, :paypal_transaction_id => transaction_id })
		@transaction.save
	end

	def create_subscription(t_id)
		@subscription = Subscription.new({:user_id => current_user.id, :transaction_id => t_id, :start_date => session[:start_date], :end_date => session[:end_date] })
		@subscription.save
		sub_id = @subscription.id
		booking_update = Booking.last
		booking_update.subscription_id = sub_id
		booking_update.save
	end

	def subscription_index
		@subscriptions = current_user.subscriptions
	end

	private
	
 	def booking_params
 	 params.require(:booking).permit(:start_date, :end_date, :no_of_rooms).merge({user_id:current_user.id})
 	end

 	
end

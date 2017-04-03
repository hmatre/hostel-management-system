class Booking < ApplicationRecord
	after_create :send_email_to_admin
	belongs_to :user
	belongs_to :hostel

	# def send_email
 #    UserMailer.welcome_booking_email(user).deliver
 #  end

  def send_email_to_admin
 	  @hostel_user = User.find(hostel.user_id)
 	  UserMailer.booking_email_admin(@hostel_user).deliver
  end
end
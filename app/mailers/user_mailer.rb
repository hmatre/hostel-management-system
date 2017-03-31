class UserMailer < ApplicationMailer
	default from: 'pulkitrahul5@gmail.com'
  def welcome_booking_email(user)
		@user = user
		#@hostel_user = hostel_user
  	mail(:to => "#{user.first_name} <#{user.email}>", :subject => "Registered")
	end
	def booking_email_admin(user)
		mail(:to => "#{user.first_name} <#{user.email}>", :subject => "please confirm")
	end
end
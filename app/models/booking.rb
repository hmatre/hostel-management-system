class Booking < ApplicationRecord
	after_create :send_email_to_admin, :send_email_to_user
	belongs_to :user
	belongs_to :hostel
	belongs_to :subscription 
	validates :no_of_rooms,numericality: true, presence: true
	validates :start_date, :end_date, presence: true
  def send_email_to_admin
 	  @hostel_user = User.find(hostel.user_id)
 	  UserMailer.booking_email_admin(@hostel_user).deliver
  end

  def send_email_to_user
    UserMailer.welcome_booking_email(user).deliver
  end
end
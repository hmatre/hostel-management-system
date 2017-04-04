class Booking < ApplicationRecord
	after_create :send_email_to_admin
	belongs_to :user
	belongs_to :hostel

	validates :no_of_rooms, :months,numericality: true, presence: true

  def send_email_to_admin
 	  @hostel_user = User.find(hostel.user_id)
 	  UserMailer.booking_email_admin(@hostel_user).deliver
  end
end
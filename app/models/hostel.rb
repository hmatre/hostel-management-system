class Hostel < ApplicationRecord
	validates :name, :no_of_rooms, :room_rent, presence: true
	validates :address, presence: true
	validates :pincode, length:{is: 6}
	validates :mobile_number, length:{is: 10}
	belongs_to :User
	has_many :bookings
end
class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
	validates :age, numericality: true
	validates :pincode, length:{is: 6}
	validates :address, :email, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role_type: [ :admin, :user ]
  has_many :hostels
  has_many :bookings
end

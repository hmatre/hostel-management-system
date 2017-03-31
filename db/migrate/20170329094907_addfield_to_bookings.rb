class AddfieldToBookings < ActiveRecord::Migration[5.0]
  def change
  	add_column :bookings, :no_of_rooms, :integer
  	add_column :bookings, :months, :integer
  	add_column :bookings, :confirm, :boolean, default: false
  end
end

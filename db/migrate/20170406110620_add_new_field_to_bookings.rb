class AddNewFieldToBookings < ActiveRecord::Migration[5.0]
  def change
  	add_column :bookings, :start_date, :datetime
  	add_column :bookings, :end_date, :datetime
  	remove_column :bookings, :months, :integer
  end
end

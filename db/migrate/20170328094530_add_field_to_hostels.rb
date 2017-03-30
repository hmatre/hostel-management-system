class AddFieldToHostels < ActiveRecord::Migration[5.0]
  def change
  	add_column :hostels, :no_of_rooms, :integer
  	add_column :hostels, :booked_rooms, :integer
  end
end

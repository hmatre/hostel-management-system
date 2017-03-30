class AddFieldsToHostels < ActiveRecord::Migration[5.0]
  def change
  	add_column :hostels, :room_rent, :integer
  	rename_column :hostels, :booked_rooms, :available_rooms
  end
end

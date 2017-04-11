class AddSubscriptionIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :subscription_id, :integer
  end
end

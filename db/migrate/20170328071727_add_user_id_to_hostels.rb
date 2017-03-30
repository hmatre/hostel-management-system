class AddUserIdToHostels < ActiveRecord::Migration[5.0]
  def change
    add_column :hostels, :user_id, :integer
  end
end

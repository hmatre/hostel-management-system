class AddFieldToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role_type, :integer
    
  end
end

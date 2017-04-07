class AddNewFieldToHostels < ActiveRecord::Migration[5.0]
  def change
  	add_column :hostels, :image, :string
  	add_column :hostels, :description, :text
  end
end

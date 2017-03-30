class CreateHostels < ActiveRecord::Migration[5.0]
  def change
    create_table :hostels do |t|
      t.string :name
      t.text :address
      t.integer :pincode
      t.string :mobile_number

      t.timestamps
    end
  end
end

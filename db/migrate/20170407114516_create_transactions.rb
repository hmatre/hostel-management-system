class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
    	t.float :amount, default: 0
    	t.integer :user_id
    	t.string :paypal_email
    	t.integer :owner_id
    	t.string :paypal_status

      t.timestamps
    end
  end
end

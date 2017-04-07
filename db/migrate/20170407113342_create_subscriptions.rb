class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
    	t.integer :user_id
    	t.integer :transaction_id
    	t.datetime :start_date
    	t.datetime :end_date

      t.timestamps
    end
  end
end

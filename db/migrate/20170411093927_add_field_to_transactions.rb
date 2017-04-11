class AddFieldToTransactions < ActiveRecord::Migration[5.0]
  def change
  	add_column :transactions, :paypal_paykey, :string
  	add_column :transactions, :paypal_transaction_id, :string
  end
end

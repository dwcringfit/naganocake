class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :client, :null => false
      t.integer :status, :null => false, default: 0
      t.integer :payment_method, :null => false
      t.integer :postage, :null => false
      t.integer :total_fee, :null => false
      t.string :address, :null => false
      t.string :post_number, :null => false
      t.string :receiver, :null => false

      t.timestamps
    end
  end
end

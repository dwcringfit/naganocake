class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :order, :null => false
      t.references :item, :null => false
      t.integer :item_count, :null => false
      t.integer :price, :null => false
      t.integer :production_status, :null => false

      t.timestamps
    end
  end
end

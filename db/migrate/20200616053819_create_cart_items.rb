class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.integer :item_id,       null: false
      t.integer :item_count,    null: false
      t.integer :client_id,     null: false

      t.timestamps
    end

    add_index :cart_items, :item_id
    add_index :cart_items, :client_id

  end
end

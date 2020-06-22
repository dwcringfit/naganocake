class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.references :item,       null: false
      t.references :client,     null: false
      t.integer :item_count,    null: false

      t.timestamps
    end
  end
end

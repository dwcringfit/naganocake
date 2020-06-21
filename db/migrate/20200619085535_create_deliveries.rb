class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.references :client,   null: false
      t.string :address,   null: false
      t.string :post_number,   null: false
      t.string :receiver,   null: false

      t.timestamps
    end
  end
end

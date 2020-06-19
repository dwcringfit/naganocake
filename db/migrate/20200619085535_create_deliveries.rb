class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.integer :client_id,   null: false, default: ""
      t.string :address,   null: false, default: ""
      t.string :post_number,   null: false, default: ""
      t.string :receiver,   null: false, default: ""

      t.timestamps
    end
  end
end

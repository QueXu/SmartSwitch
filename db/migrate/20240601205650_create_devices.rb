class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :mac_address
      t.string :feed_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :devices, :mac_address, unique: true
  end
end

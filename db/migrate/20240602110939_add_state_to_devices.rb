class AddStateToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :state, :string
  end
end

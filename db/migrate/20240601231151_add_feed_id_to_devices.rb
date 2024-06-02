class AddFeedIdToDevices < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:devices, :feed_id)
      add_column :devices, :feed_id, :string
    end
  end
end
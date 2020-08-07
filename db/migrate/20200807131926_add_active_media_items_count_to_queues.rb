class AddActiveMediaItemsCountToQueues < ActiveRecord::Migration[6.0]
  def change
    add_column :media_queues, :active_media_items_count, :integer, default: 0, null: false
  end
end

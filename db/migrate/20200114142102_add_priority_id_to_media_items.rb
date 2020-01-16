class AddPriorityIdToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :media_items, :media_priority, null: true, foreign_key: true
  end
end

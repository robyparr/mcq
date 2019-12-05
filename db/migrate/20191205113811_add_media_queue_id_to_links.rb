class AddMediaQueueIdToLinks < ActiveRecord::Migration[6.0]
  def change
    add_reference :links, :media_queue, null: false, foreign_key: true
  end
end

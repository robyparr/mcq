class AddEstimatedConsumptionTimeToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :estimated_consumption_time, :integer, null: true
  end
end

class AddConsumptionDifficultyToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :consumption_difficulty, :string, null: true
  end
end

class AddSnoozeUntilToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :snooze_until, :datetime, null: true
  end
end

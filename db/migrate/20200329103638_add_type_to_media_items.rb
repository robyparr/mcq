class AddTypeToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :type, :string
  end
end

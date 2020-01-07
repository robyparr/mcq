class RenameLinksTableToMediaItemsTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :links, :media_items
  end
end

class AddServiceInformationToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :service_id, :string, null: true
    add_column :media_items, :service_type, :string, null: true
  end
end

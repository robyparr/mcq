class AddCompleteToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :complete, :boolean, null: false, default: false
  end
end

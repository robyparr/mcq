class CreateMediaNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :media_notes do |t|
      t.string :title
      t.text :content
      t.references :media_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

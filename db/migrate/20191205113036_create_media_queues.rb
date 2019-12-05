class CreateMediaQueues < ActiveRecord::Migration[6.0]
  def change
    create_table :media_queues do |t|
      t.string :name, null: false
      t.string :color, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

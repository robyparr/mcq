class CreateMediaPriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :media_priorities do |t|
      t.string :title, null: false
      t.integer :priority, null: false
      t.references :user, null: false, foreign_key: true
    end

    add_index :media_priorities, [:user_id, :title], unique: true
    add_index :media_priorities, [:user_id, :priority], unique: true
  end
end

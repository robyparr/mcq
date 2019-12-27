class CreateActivityLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_logs do |t|
      t.bigint :loggable_id
      t.string :loggable_type
      t.string :action

      t.timestamps
    end
  end
end

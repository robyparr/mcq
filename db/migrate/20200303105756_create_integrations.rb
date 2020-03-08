class CreateIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :service
      t.string :request_token
      t.string :auth_token
      t.string :redirect_token
      t.string :username
      t.timestamps
    end
  end
end

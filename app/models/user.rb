class User < ApplicationRecord
  include Clearance::User

  has_many :media_items, dependent: :destroy
  has_many :queues, class_name: 'MediaQueue', dependent: :destroy
  has_many :media_priorities, dependent: :destroy
  has_many :notes, through: :media_items
  has_many :integrations, dependent: :destroy

  has_one :pocket_integration,
    -> { where(service: 'Pocket') },
    class_name: 'Integration'
end

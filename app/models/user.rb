class User < ApplicationRecord
  include Clearance::User

  has_many :media_items, dependent: :destroy
  has_many :queues, class_name: 'MediaQueue', dependent: :destroy
end

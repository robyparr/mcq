class User < ApplicationRecord
  include Clearance::User

  has_many :links, dependent: :destroy
  has_many :queues, class_name: 'MediaQueue', dependent: :destroy
end

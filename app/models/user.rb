class User < ApplicationRecord
  include Clearance::User

  has_many :links, dependent: :destroy
end

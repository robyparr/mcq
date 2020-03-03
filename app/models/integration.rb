class Integration < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where('auth_token IS NOT NULL') }
end

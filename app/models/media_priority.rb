class MediaPriority < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }
  validates :priority, presence: true, uniqueness: { scope: :user_id }
end

class MediaQueue < ApplicationRecord
  belongs_to :user

  has_many :media_items, dependent: :nullify
  has_many :active_media_items,
    -> { merge(MediaItem.not_completed.not_snoozed) },
    class_name: 'MediaItem',
    dependent: :nullify

  validates :name, presence: true
  validates :color, presence: true
end

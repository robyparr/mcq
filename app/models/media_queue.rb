class MediaQueue < ApplicationRecord
  belongs_to :user

  has_many :links, dependent: :nullify
  has_many :active_links,
    -> { where(complete: false) },
    class_name: 'Link',
    dependent: :nullify

  validates :name, presence: true
  validates :color, presence: true
end

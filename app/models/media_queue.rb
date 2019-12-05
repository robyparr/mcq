class MediaQueue < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :nullify

  validates :name, presence: true
  validates :color, presence: true
end

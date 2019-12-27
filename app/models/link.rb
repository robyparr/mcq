class Link < ApplicationRecord
  belongs_to :user
  belongs_to :queue, class_name: 'MediaQueue', foreign_key: :media_queue_id

  validates :url, presence: true

  def title_or_url
    title.presence || url
  end

  def mark_complete
    return false if complete?

    update_attributes complete: true
  end
end

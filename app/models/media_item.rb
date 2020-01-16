class MediaItem < ApplicationRecord
  include Loggable

  enum consumption_difficulty: {
    easy:   'easy',
    medium: 'medium',
    hard:   'hard'
  }

  belongs_to :user
  belongs_to :queue, class_name: 'MediaQueue', foreign_key: :media_queue_id
  belongs_to :priority,
    class_name: 'MediaPriority',
    foreign_key: :media_priority_id,
    optional: true

  has_many :notes, class_name: 'MediaNote', dependent: :destroy

  validates :url, presence: true

  after_create :log_creation!

  def title_or_url
    title.presence || url
  end

  def mark_complete
    return false if complete?

    with_log(:mark_complete) do
      update complete: true
    end
  end

  private

  def log_creation!
    activity_logs.create action: :create
  end
end

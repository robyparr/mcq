require 'open-uri'

class MediaItem < ApplicationRecord
  include Loggable
  include Snoozeable

  MEDIA_TYPES = %i[
    Article
    Video
  ].freeze

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
  after_save :update_queue_counter_cache
  after_destroy :update_queue_counter_cache

  scope :completed, -> { where(complete: true) }
  scope :not_completed, -> { where(complete: false) }

  def title_or_url
    title.presence || url
  end

  def mark_complete
    return false if complete?

    with_log(:mark_complete) do
      update complete: true
    end
  end

  def estimated_consumption_time
    return super unless self[:estimated_consumption_time].present?

    (self[:estimated_consumption_time] / 60.0).ceil
  end

  def estimate_consumption_difficulty!
    return unless estimated_consumption_time.present?
    return if consumption_difficulty.present?

    difficulties = self.class.consumption_difficulties.keys
    self.consumption_difficulty =
      if estimated_consumption_time <= 5
        difficulties[0]
      elsif estimated_consumption_time <= 20
        difficulties[1]
      else
        difficulties[2]
      end
  end

  def method_missing(method, *args)
    super unless type.present?
    super unless MEDIA_TYPES.map { |type| :"#{type.downcase}?" }.include?(method)

    :"#{self.type.downcase}?" == method
  end

  def estimate_consumption_time!
    raise NotImplementedError, "#{self.class} must implement `estimate_consumption_time!`"
  end

  def retrieve_metadata_from_source!
    raise NotImplementedError, "#{self.class} must implement `retrieve_metadata_from_source!`"
  end

  private

  def log_creation!
    activity_logs.create action: :create
  end

  def snoozeable?
    !complete?
  end

  def update_queue_counter_cache
    queue_changes = saved_changes[:media_queue_id]

    if queue_changes.present? && queue_changes.first.present?
      old_queue = MediaQueue.find queue_changes.first
      old_queue.update_active_media_items_count!
    end

    queue.update_active_media_items_count!
  end
end

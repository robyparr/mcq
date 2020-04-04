require 'open-uri'

class MediaItem < ApplicationRecord
  include Loggable

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

  private

  def log_creation!
    activity_logs.create action: :create
  end
end

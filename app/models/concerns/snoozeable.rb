module Snoozeable
  extend ActiveSupport::Concern

  included do
    scope :snoozed, -> { where('snooze_until > ?', Time.current) }
    scope :not_snoozed, -> { where('snooze_until IS NULL OR snooze_until <= ?', Time.current) }
  end

  def snooze(until_time:)
    snooze_until = time_for_snooze_until(until_time)
    return false unless snoozeable? && valid_snooze_until_value?(snooze_until)

    log_action = snooze_until.nil? ? :unsnoozed : :snoozed
    with_log(log_action) do
      update snooze_until: snooze_until
    end
  end

  def snoozed?
    return false if snooze_until.blank?

    snooze_until > time_for_snooze_until
  end

  def formatted_snooze_until
    return unless snoozed?

    snooze_until.strftime('%F at %l %p')
  end

  private

  SNOOZE_UNTIL_TIME = {
    hour: 9,
    min: 0,
  }.freeze

  def valid_snooze_until_value?(snooze_until)
    snooze_until.nil? || snooze_until > time_for_snooze_until
  end

  def time_for_snooze_until(datetime = Time.current)
    datetime.try(:change, SNOOZE_UNTIL_TIME)
  end

  def snoozeable?
    raise NotImplementedError, "#{self.class} needs to implement snoozeable?"
  end
end

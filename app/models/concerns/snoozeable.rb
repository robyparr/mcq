module Snoozeable
  extend ActiveSupport::Concern

  included do
    scope :snoozed, -> { where('snooze_until > ?', Time.zone.now.beginning_of_day) }
    scope :not_snoozed, -> { where('snooze_until IS NULL OR snooze_until <= ?', Time.zone.now.beginning_of_day) }
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

  private

  def valid_snooze_until_value?(snooze_until)
    snooze_until.nil? || snooze_until > time_for_snooze_until
  end

  def time_for_snooze_until(datetime = Time.zone.now)
    datetime.try(:beginning_of_day)
  end

  def snoozeable?
    raise NotImplementedError, "#{self.class} needs to implement snoozeable?"
  end
end

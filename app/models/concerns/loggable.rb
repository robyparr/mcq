module Loggable
  extend ActiveSupport::Concern

  included do
    has_many :activity_logs, as: :loggable
  end

  def with_log(action, &block)
    ActiveRecord::Base.transaction do
      result = block.call
      raise ActiveRecord::Rollback unless result

      activity_logs.create!(action: action)

      result
    end
  end
end

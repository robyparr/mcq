class PullPocketItemsJob < ApplicationJob
  queue_as :default

  def perform
    User.includes(:pocket_integration).find_each do |user|
      next unless user.pocket_integration.present?

      Pocket::PullItems.call user, user.pocket_integration.id
    end
  end
end

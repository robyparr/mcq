require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour, 'pocket.pull_items') { PullPocketItemsJob.perform_later }
end

set :output, 'log/cron.log'

every 1.hour do
  runner 'PullPocketItemsJob.perform_later'
end

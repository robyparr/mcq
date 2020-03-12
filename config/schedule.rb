ENV.each { |variable, value| env variable, value }
set :output, "#{Whenever.path}/log/cron.log"

every 1.hour do
  runner 'PullPocketItemsJob.perform_later'
end

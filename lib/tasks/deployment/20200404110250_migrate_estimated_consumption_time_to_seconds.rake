namespace :after_party do
  desc 'Deployment task: migrate_estimated_consumption_time_to_seconds'
  task migrate_estimated_consumption_time_to_seconds: :environment do
    puts "Running deploy task 'migrate_estimated_consumption_time_to_seconds'"

    # Put your task implementation HERE.
    pastel  = Pastel.new
    success = pastel.green.detach
    warning = pastel.yellow.detach

    MediaItem.find_each do |media_item|
      unless media_item.estimated_consumption_time.present?
        print warning.('.')
        next
      end

      time_in_minutes = media_item.estimated_consumption_time.minutes
      media_item.update_attributes estimated_consumption_time: time_in_minutes.seconds
      print success.('.')
    end

    puts success.('Done.')

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end

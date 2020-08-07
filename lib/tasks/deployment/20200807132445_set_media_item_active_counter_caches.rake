namespace :after_party do
  desc 'Deployment task: set_media_item_active_counter_caches'
  task set_media_item_active_counter_caches: :environment do
    puts "Running deploy task 'set_media_item_active_counter_caches'"

    # Put your task implementation HERE.
    pastel  = Pastel.new
    success = pastel.green.detach

    MediaQueue.find_each do |queue|
      media_item = queue.media_items.first
      next if media_item.blank?

      media_item.send :update_queue_counter_cache
      print success.('.')
    end

    puts success.('Done.')

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end

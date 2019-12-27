require 'rainbow/refinement'
using Rainbow

namespace :migrate do
  desc "Create activity logs for links created before logging"
  task link_creation_activity_logs: :environment do
    puts "Processing #{Link.count} links..."

    Link.find_each do |link|
      if link.activity_logs.any?
        print 'S'.green
        next
      end

      link.activity_logs.create action: :create, created_at: link.created_at
      print '.'.green
    end
  end

end

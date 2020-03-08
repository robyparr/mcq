if Rails.env.development?
  %x(bundle exec whenever --update-crontab --set environment='development')
end

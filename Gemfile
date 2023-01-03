source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.0', '= 6.0.4.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'clearance', '~> 2.5'
gem 'rainbow', '~> 3.0'
gem 'ruby-readability', '~> 0.7.0'
gem 'httparty', '~> 0.21.0'
# gem 'delayed_job_active_record'
# gem 'daemons', '~> 1.3', '>= 1.3.1'
gem 'clockwork', '~> 2.0', '>= 2.0.4'
gem 'after_party', '~> 1.11', '>= 1.11.2'
gem 'pastel', '~> 0.7.3'
gem 'kaminari', '~> 1.2', '>= 1.2.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.9'
  gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
  gem 'shoulda-callback-matchers', '~> 1.1', '>= 1.1.4'
  gem 'capybara', '~> 3.29'
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.6'
  gem 'webdrivers', '~> 4.1', '>= 4.1.3'
  gem 'test-prof', '~> 0.10.2'
  gem 'webmock', '~> 3.8', '>= 3.8.2'
  gem 'simplecov', '~> 0.18.5'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet', '~> 6.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

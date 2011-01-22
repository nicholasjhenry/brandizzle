source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem 'haml'
gem 'haml-rails'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # gem 'autotest'
  # gem 'autotest-rails'
  gem 'cucumber-rails', "0.3.2"
  gem 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git'
  gem "capybara", "~>0.4"
  gem "spork", :git => "git://github.com/chrismdp/spork.git"
  gem "database_cleaner", "~>0.6"
  gem "launchy"
  gem 'rspec', "~>2.4"
  gem 'rspec-rails', "~>2.4"
  gem "fuubar"
end

group :test do
  gem "bourne", "~>1.0"
  gem "shoulda", "~>2.11"
  gem 'cover_me', '>= 1.0.0.rc5'
  gem 'factory_girl'
end

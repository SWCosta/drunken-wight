source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'capistrano'
gem 'rvm-capistrano'
#gem 'passenger', '3.0.12'

gem 'pg'

gem 'therubyracer'
gem 'jquery-rails'
gem 'hpricot' #need for haml-rails html2haml converter
gem 'ruby_parser' #need for haml-rails html2haml converter
gem 'haml-rails'
gem 'hirb'
gem 'awesome_print'
gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
gem 'fancybox-rails'

gem 'devise'
gem 'simple_form'
#gem 'will_paginate'
#gem 'carrierwave'
#gem 'rmagick'
#gem 'ancestry'

gem 'friendly_id'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :development, :test do
  gem "rspec-rails", "~> 2.6"
  gem "debugger"
end

group :test do
  gem 'turn', '0.8.2', :require => false # Pretty printed test output
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'spork', '~> 0.9.0.rc'
  gem 'guard-spork'
  gem 'shoulda'
  gem 'rb-inotify' if RUBY_PLATFORM =~ /linux/i # on linux
  gem 'libnotify' if RUBY_PLATFORM =~ /linux/i # on linux
end

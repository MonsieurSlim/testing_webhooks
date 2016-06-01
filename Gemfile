source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.rc1', '< 5.1'
# Use postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

#user authentication
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-google'
#role based access control
gem 'pundit'
#scoped ids
gem 'sequenced'
#use slugs for projects
gem 'friendly_id'
#store attachemnts
gem "refile", require: "refile/rails"
gem 'refile-postgres'
# gem "refile-mini_magick" #not rails 5 compatible
#tagging
gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on'#there's an open issue with rails5 so we're pulling from master
# auditlogs
gem 'paper_trail'
#soft-delete
# gem 'paranoia', "~> 2.0" #does not support rails 5 yet
# create ordered lists
gem "acts_as_list"


group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec', '>=3.5.0.beta3'
  gem 'simplecov', :require => false
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rspec-rails', '>= 3.5.0.beta3'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

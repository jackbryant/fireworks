source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


gem 'paperclip'
gem 'aws-sdk'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
    gem 'rails_12factor'
end

group :development, :test do
    #RRpec for tests
    gem 'rspec-rails'
    
    # capybara for the describe language
    gem 'capybara'
    
    gem 'cucumber-rails', :require => false
    # database_cleaner is not required, but highly recommended
    gem 'database_cleaner'
    
    
    # Shoulda matchers for Rspec (makes it easier to write tests)
    gem 'shoulda-matchers'
    
    #factory girl for writing better tests  
    gem "factory_girl_rails", "~> 4.0"
    
    #rails 4 Jasmine settings
    gem 'jasmine-core', github: 'pivotal/jasmine'
    gem 'jasmine', github: 'pivotal/jasmine-gem' 
    
    #to test emails 
    gem 'capybara-email'

     # gem 'guard'
     gem 'guard-cucumber'
     
end





# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

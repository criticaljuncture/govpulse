# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

# Add testing gems to config
config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
config.gem 'seanhussey-woulda',  :lib => 'woulda',  :source => 'http://gems.github.com'
config.gem 'floehopper-mocha',   :lib => 'mocha',   :source => 'http://gems.github.com'
config.gem 'rails-test-serving', :version => '0.1.4.2', :lib => 'rails_test_serving'
config.gem 'jgre-monkeyspecdoc', :lib => 'monkeyspecdoc',    :version => '0.9.5'

config.gem "rspec", :lib => false, :version => "1.3.0"
config.gem "rspec-rails", :lib => false, :version => "1.3.2"
config.gem "webrat", :version => "0.7.0"
config.gem "spork", :lib => false, :version => "0.7.5"
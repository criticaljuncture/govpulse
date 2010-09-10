require "bundler"
Bundler.setup(:default, :deployment)

# thinking sphinx cap tasks
require 'thinking_sphinx/deploy/capistrano'
# hoptoad deploy notifications, etc
require 'hoptoad_notifier/capistrano'

# deploy recipes
require 'thunder_punch'


#############################################################
# Set Basics
#############################################################

set :application, "govpulse"
set :user, "deploy"

# 
if File.exists?(File.join(ENV["HOME"], ".ssh", "govpulse-prod-provision"))
  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "govpulse-prod-provision")]
else
  puts "~/.ssh/govpulse-prod-provision was not available falling back to ~/.ssh/id_rsa"
  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
end

set :ec2_config_location, File.join(File.dirname(__FILE__), "amazon.yml")

ssh_options[:paranoid] = false
set :use_sudo, true
default_run_options[:pty] = true


#############################################################
# Git-based Deployment Setup
#############################################################

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }


set :finalize_deploy, false
# we don't need this because we have an asset server
# and we also use varnish as a cache server. Thus 
# normalizing timestamps is detrimental.
set :normalize_asset_timestamps, false


set :migrate_target, :current


#############################################################
# Set Branch
#############################################################

set(:branch) { `git branch`.match(/\* (.*)/)[1] }


#############################################################
# General Settings  
#############################################################

set :rails_env,  "production"                           
set :deploy_to,  "/var/www/apps/#{application}" 
#set :domain,     "204.236.234.36" #gp1_ec2 -- ec2-204-236-234-36.compute-1.amazonaws.com
set :domain,     "ec2-184-73-55-26.compute-1.amazonaws.com" #ec2 large server
set :url,        "#{domain}"     
set :server_url, "#{domain}"


role :proxy,  domain
role :static, domain
role :worker, domain, {:primary=>true}
role :app,    domain
role :db ,    domain, {:primary => true}


#############################################################
# Database Settings
#############################################################

set :remote_db_name, "govpulse_production"
set :db_path,        "#{shared_path}/db"
set :sql_file_path,  "#{shared_path}/db/#{remote_db_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.sql"


#############################################################
# SCM Settings
#############################################################
set :scm,              :git          
set :github_user_repo, 'criticaljuncture'
set :github_project_repo, 'govpulse'
set :deploy_via,       :remote_cache
set :repository, "git@github.com:#{github_user_repo}/#{github_project_repo}.git"
set :github_username, 'criticaljuncture' 


#############################################################
# Git
#############################################################

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }
set :git_enable_submodules, true


#############################################################
# Run Order
#############################################################

# Do not change below unless you know what you are doing!

after "deploy:update_code",       "symlinks:create"
after "symlinks:create",          "deploy:set_rake_path"
after "deploy:set_rake_path",     "bundler:fix_bundle"
after "bundler:fix_bundle",       "deploy:migrate"
after "deploy:migrate",           "thinking_sphinx:restart"
after "thinking_sphinx:restart",  "passenger:restart"


#############################################################
# Symlinks for Static Files
#############################################################
set :custom_symlinks, {
  'config/api_keys.yml'                       => 'config/api_keys.yml',
  'config/production.sphinx.conf'             => 'config/production.sphinx.conf',
  'config/newrelic.yml'                       => 'config/newrelic.yml',
  'config/amazon.yml'                         => 'config/amazon.yml',
  'config/initializers/cloudkicker_config.rb' => 'config/cloudkicker_config.rb',
  
  'data'            => 'data',
  'db/sphinx'       => 'db/sphinx',
  'public/sitemaps' => 'sitemaps'
}


#############################################################
#                                                           #
#                                                           #
#                         Recipes                           #
#                                                           #
#                                                           #
#############################################################


#############################################################
# Get Remote Files
#############################################################

namespace :filesystem do
  task :load_remote do
    run_locally("rsync --verbose  --progress --stats --compress -e 'ssh -p #{port}' --recursive --times --perms --links #{user}@#{domain}:#{deploy_to}/shared/data data")
  end
end
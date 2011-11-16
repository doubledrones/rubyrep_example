set :application, "rubyrep_example"
set :repository,  "git://github.com/doubledrones/rubyrep_example.git"

set :ruby_version, "1.9.2"
set :ruby_patch, "290"

set :example_server, "8.8.8.8"
set :user, "example_user"
ssh_options[:port] = 666 # change port to avoid scanners

set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :rvm_gemset, "#{application}-#{rails_env}"

#
# Next lines depends on previous configuration (please do not change them)
#

role :web, example_server                          # Your HTTP server, Apache/etc
role :app, example_server                          # This may be the same as your `Web` server
role :db,  example_server, :primary => true                      # This is where Rails migrations will run

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                               # Load RVM's capistrano plugin.
set :rvm_ruby_string, "#{ruby_version}@#{rvm_gemset}"  # Or whatever env you want it to run in.
require "bundler/capistrano"
require 'capistrano/ext/rvm-bundler'

set :scm, :git
set :git_shallow_clone, 1
set :deploy_via, :copy
set :use_sudo, false
set :deploy_root, "/home/#{user}"
set :deploy_to, "#{deploy_root}/rubyrep-#{rails_env}"

set :rvm_type, :user  # Copy the exact line. I really mean :user here

before "bundler:install", "rvm:gemset:create"
before "bundle:install", "bundler:install"

namespace :rubyrep do
  desc "perform rubyrep scan"
  task :scan, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && rvm '#{rvm_ruby_string}' && rubyrep scan --detailed=full -c #{current_path}/config/rubyrep-#{rails_env}.conf"
  end

  desc "perform rubyrep sync"
  task :sync, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && rvm '#{rvm_ruby_string}' && rubyrep sync --detailed=full -c #{current_path}/config/rubyrep-#{rails_env}.conf"
  end
end

require "recipiez/capistrano"

server "176.58.115.227", :web, :app, :db, primary: true

set :application, "taygeta"
set :user, "deployer"
set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, 'staging'

set :scm, "git"
set :repository,  "git@github.com:rebelcolony/taygeta.git"
set :branch, "staging"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 8888 
ssh_options[:keys] = %w(/Users/alastairbrunton/.ssh/blissio)

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end

set :num_servers, 2
set :start_port, 3050
set :web_port, 80

set :app_domain, "staging.applusnorway.com"
set :domain, app_domain

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  
  task :clean_expired, :roles => [:web], :except => { :no_release => true } do
      echo "Skipping removing unneeded assets"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :symlink_uploads, roles: :app do
    run "rm -drf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/system/uploads #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_uploads"

  task :symlink_pdf_cache, roles: :app do
    run "rm -drf #{release_path}/public/reports"
    run "ln -nfs #{shared_path}/system/reports #{release_path}/public/reports"
  end
  after "deploy:finalize_update", "deploy:symlink_pdf_cache"

  desc "Restarts the mod thin instances and nginx"
  task :restart do
    sudo "/usr/local/bin/monit restart all -g taygeta"
  end
end

# Bundler info
set :bundle_dir, "#{shared_path}/bundle"
require "bundler/capistrano"
#

require 'recipiez/capistrano'

set :application, "taygeta"
set :rails_env, 'production'

set :repository,  "git@github.com:rebelcolony/taygeta.git"
set :scm, :git
set :branch, 'master'

set :deploy_via, :remote_cache
default_run_options[:pty] = true

server "176.58.107.44", :web, :app, :db, primary: true

set :num_servers, 2
set :start_port, 3050
set :web_port, 80

set :app_domain, "www.applusnorway.com"
set :domain, app_domain

ssh_options[:keys] = %w(/Users/alastairbrunton/.ssh/simplyexcited)
ssh_options[:port] = 9999
ssh_options[:forward_agent] = true


set :deploy_to, "/var/www/apps/#{application}" # defaults to "/u/apps/#{application}"
set :user, "deployer"            # defaults to the currently logged in user
set :runner, user


after "deploy:restart", "deploy:cleanup"

namespace :deploy do

  desc "Restarts the mod thin instances and nginx"
  task :restart do
    sudo "/usr/local/bin/monit restart all -g taygeta"
  end
end

# Bundler info
set :bundle_dir, "#{shared_path}/bundle"
require "bundler/capistrano"
##
# -----------------------------------------------




namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end


namespace :deploy do

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

end

#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Alvernon::Application.load_tasks

desc "Outputs rails log without assets strings."
task :nifty_log do
  puts "Application log:"
  system 'tail -f log/development.log | grep -vE "(^$|asset)"'
end

desc "Runs assets server to avoid deadlocking while generating PDFs"
task :asset_server do
  puts "Starting assets server at localhost:3001..."
  system "rails server -p 3001 -e test"
end

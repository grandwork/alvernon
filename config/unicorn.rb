root = "/var/www/apps/taygeta/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
preload_app true


listen "/tmp/unicorn.blog.sock"
worker_processes 1
timeout 30
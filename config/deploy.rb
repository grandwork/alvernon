set :stages, %w(staging production)
require 'capistrano/ext/multistage'

require 'recipiez/capistrano'


        require './config/boot'
        require 'airbrake/capistrano'

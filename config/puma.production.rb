#!/usr/bin/env puma

port 30000

# NOT DRY...

directory '/home/foobar/line_parrot_production/current'
rackup "/home/foobar/line_parrot_production/current/config.ru"
environment 'production'

tag ''

pidfile "/home/foobar/line_parrot_production/shared/tmp/pids/puma.pid"
state_path "/home/foobar/line_parrot_production/shared/tmp/pids/puma.state"
stdout_redirect '/home/foobar/line_parrot_production/current/log/puma.access.log', '/home/foobar/line_parrot_production/current/log/puma.error.log', true

threads 0,16

bind 'unix:///home/foobar/line_parrot_production/shared/tmp/sockets/puma.sock'
workers 0

restart_command 'bundle exec puma'

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = ''
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

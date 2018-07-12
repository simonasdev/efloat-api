require 'capistrano-db-tasks'
# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "efloat-api"
set :repo_url, "git@me.bitbucket.org:efloat/efloat-api.git"
set :deploy_to, "/home/efloat/efloat-api"

append :rvm_map_bins, 'rails', 'sidekiq'
set :nvm_map_bins, %w{node npm yarn}
set :nvm_node, 'v10.3.0'

append :linked_files, "config/master.key", 'config/puma.rb'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :ssh_options, {
  forward_agent: false,
  auth_methods: %w[publickey],
  keys: %w[~/.ssh/bitbucket]
}

set :db_local_clean, true

set :init_system, :systemd

namespace :puma do
  desc 'Restart puma'
  task :restart do
    on roles(:app) do
      execute 'systemctl --user restart puma'
    end
  end
end

namespace :deploy do
  after 'deploy:finished', 'puma:restart'
end

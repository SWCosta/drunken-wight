set :application, "EM-Tippspiel"
set :repository,  "git@github.com:yuszuv/drunken-wight.git"

set :scm, :git
ssh_options[:forward_agent] = true

#use capistrano with rvm
set :rvm_ruby_string, "ruby-1.9.2-p318@tippspiel"
set :rvm_type, :system
require 'rvm/capistrano'


set :deploy_to, "/opt/tippspiel"
set :deploy_via, :remote_cache

server "fucklove.de", :web, :app, :db, :primary => true
set :user, "deployer"
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do
  desc "symlinks a database config in the shared directory"
  task :symlink_db do
    run "touch #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

before "deploy:finalize_update", "deploy:symlink_db"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

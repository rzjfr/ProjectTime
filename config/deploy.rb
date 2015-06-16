# config valid only for current version of Capistrano
lock '3.3.5'
require 'sshkit/dsl'
set :application, 'project_time'
set :scm, :git
set :repo_url, 'git@bitbucket.org:rzjfr/projecttime.git'
set :branch, 'master'
set :deploy_to, '/home/deploy/project_time'
set :linked_dirs, %w{tmp/pids log public/assets}
set :keep_releases, 20
set :enable_ssl, true
set :pty, true
set :bundle_flags, "--verbose"

  namespace :assets do
    desc "compile assets"
    task :precompile do
      on roles(:all) do
        within "#{current_path}" do
          with rails_env: :production do
            execute :rake, "assets:precompile"
          end
        end
      end
    end
  end

  namespace :database do
    desc "Seed the database"
    task :seed do
      on roles(:all) do
        within "#{current_path}" do
          with rails_env: :production do
            execute :rake, "db:seed"
          end
        end
      end
    end
    desc "migrate database"
    task :migrate do
      on roles(:all) do
        within release_path do
          with rails_env: fetch(:stage) do
            execute :rake, "db:migrate"
          end
        end
      end
    end
  end

  namespace :deploy do
    after :restart, :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        # Here we can do anything such as:
        # within release_path do
        #   execute :rake, 'cache:clear'
        # end
    end
  end

  namespace :check do
    desc "Check that we can access everything"
    task :write_permissions do
      on roles(:all) do |host|
        if test("[ -w #{fetch(:deploy_to)} ]")
          info "#{fetch(:deploy_to)} is writable on #{host}"
        else
          error "#{fetch(:deploy_to)} is not writable on #{host}"
        end
      end
    end
    desc "Check if agent forwarding is working"
    task :forwarding do
      on roles(:all) do |h|
        if test("env | grep SSH_AUTH_SOCK")
          info "Agent forwarding is up to #{h}"
        else
          error "Agent forwarding is NOT up to #{h}"
        end
      end
    end
    desc "Makes sure local git is in sync with remote."
    task :revision do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        info " WARNING: HEAD is not the same as origin/master"
        puts " Run `git push` to sync changes."
        exit
      end
    end
  end

end

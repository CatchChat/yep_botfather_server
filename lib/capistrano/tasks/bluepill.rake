namespace :bluepill do

  desc 'Bluepill load'
  task :load do
    pidfile  = fetch(:pidfile) || 'tmp/pids/server.pid'
    rack_env = fetch(:rack_env) || fetch(:stage)
    on roles(:app) do
      within current_path do
        execute :sudo, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} WORKING_DIR=#{current_path} RACK_ENV=#{rack_env} PIDFILE=#{pidfile} bluepill load yep_botfather_server.pill"
      end
    end
  end

  desc 'Bluepill start'
  task :start do
    on roles(:app) do
      execute :sudo, "bluepill yep_botfather_server start"
    end
  end

  desc 'Bluepill restart'
  task :restart do
    on roles(:app) do
      execute :sudo, "bluepill yep_botfather_server restart"
    end
  end

  desc 'Bluepill stop'
  task :stop do
    on roles(:app) do
      execute :sudo, "bluepill yep_botfather_server stop"
    end
  end

  desc 'Bluepill quit'
  task :quit do
    on roles(:app) do
      execute :sudo, "bluepill yep_botfather_server quit"
    end
  end

  desc 'Bluepill status'
  task :status do
    on roles(:app) do
      execute :sudo, "bluepill yep_botfather_server status"
    end
  end
end

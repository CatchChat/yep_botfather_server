namespace :yep_botfather_server do
  desc 'Start yep_botfather_server server'
  task :start do
    on roles(:app) do
      pidfile  = fetch(:pidfile) || 'tmp/pids/server.pid'
      rack_env = fetch(:rack_env) || fetch(:stage)
      within current_path do
        if server_is_running?(rack_env)
          info 'Server is running.'
        else
          info "Starting..."
          execute "PIDFILE=#{pidfile} RACK_ENV=#{rack_env} ruby yep_botfather_server.rb >> log/#{rack_env}.log 2>&1 &"
        end
      end
    end
  end

  desc 'Stop yep_botfather_server server'
  task :stop do
    on roles(:app) do
      pidfile  = fetch(:pidfile) || 'tmp/pids/server.pid'
      rack_env = fetch(:rack_env) || fetch(:stage)
      within current_path do
        execute :kill, "-TERM `ps aux | grep '[r]uby yep_botfather_server.rb >> log/#{rack_env}.log' | grep -v grep | cut -c 10-16` > /dev/null 2>&1 || true"
        5.times { print '.'; sleep 1 }
        puts "\n"
        execute :kill, "-9 `ps aux | grep '[r]uby yep_botfather_server.rb >> log/#{rack_env}.log' | grep -v grep | cut -c 10-16` > /dev/null 2>&1 || true"
        execute :rm, "#{pidfile} > /dev/null 2>&1 || true"
      end
    end
  end

  desc 'Restart yep_botfather_server server'
  task :restart do
    on roles(:app) do
      invoke 'yep_botfather_server:stop'
      invoke 'yep_botfather_server:start'
    end
  end

  def server_is_running?(rack_env)
    !`ps aux | grep '[r]uby yep_botfather_server.rb >> log/#{rack_env}.log`.empty?
  end
end

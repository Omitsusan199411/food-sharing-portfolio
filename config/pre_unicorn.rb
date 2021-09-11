# 全てコンテナ内に適用されるもの（ローカルPCではない）
# __FILE__は現在実行中のソースファイルファイル名（ここではpre_unicorn.rbのこと）を基点にして、第一引数のパスを探す。第二引数の相対パスで返す。なお、supervisorからpre_unicorn.rbにつながっている
# File.expand_pathで相対パスを絶対パスに変換する。
# app_path = /var/www/app
app_path = File.expand_path('../../', __FILE__)

worker_processes 2

working_directory app_path

# listen = /var/www/app/root/tmp/unicorn.sock
listen File.expand_path('/root/tmp/unicorn.sock', app_path)

# listen = /var/www/app/root/tmp/unicorn.pid
pid File.expand_path('/root/tmp/unicorn.pid', app_path)


stderr_path = "#{app_path}/log/unicorn.stderr.log"

stdout_path = "#{app_path}/log/unicorn.stdout.log"

timeout 60


preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
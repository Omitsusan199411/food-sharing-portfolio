# 全てコンテナ内のディレクトリを表す（ローカルPCではない）
# __FILE__は現在実行中のソースファイルファイル名（ここではpre_unicorn.rbのこと）のこと。
# File.expand_pathにより、第二引数（__FILE__）を基点にして、第一引数のパスを探し、第二引数の相対パスとして返す。なお、supervisorからpre_unicorn.rbにつながっている。
# File.expand_pathは、さらに得た相対パスを絶対パスに変換する。
# ../../はprd_unicorn.rbから２階層上のパスを指定している。
# app_path = /var/www/app
app_path = File.expand_path('../../', __FILE__)

worker_processes 2

working_directory app_path

# listen = /var/www/app/tmp/sockets/unicorn.sock
# listen File.expand_path('../../tmp/sockets/unicorn.sock', __FILE__)
listen "#{app_path}/tmp/sockets/unicorn.sock"

# listen = /var/www/app//tmp/sockets/unicorn.pid
# pid File.expand_path('../../tmp/pids/unicorn.pid', __FILE__)
pid "#{app_path}/tmp/sockets/unicorn.sock"

# unicornのエラログー・出力ログを標準エラー・標準出力に吐き出す
stderr_path = $stderr
stdout_path = $stdout

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
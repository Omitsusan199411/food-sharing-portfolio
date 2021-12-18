# 全てコンテナ内のディレクトリを表す（ローカルPCではない）
# __FILE__は現在実行中のソースファイルファイル名（ここではpre_unicorn.rbのこと）のこと。
# File.expand_pathにより、第二引数（__FILE__）を基点にして、第一引数のパスを探し、第二引数の相対パスとして返す。なお、supervisorからpre_unicorn.rbにつながっている。
# File.expand_pathは、さらに得た相対パスを絶対パスに変換する。
# ../../はprd_unicorn.rbから２階層上のパスを指定している。
# app_path = /var/www/app
app_path = File.expand_path('../../', __FILE__)

worker_processes 2

# unicornの起動コマンド（bundle exec "unicorn_rails -c config/prd_unicorn.rb -E prd"）が実行されるディレクトリ
working_directory app_path

# Nginxからのリクエストを受信するファイル（Nginxのunixドメインソケットのパスと同一のものにすること）
listen '/var/www/app/tmp/sockets/unicorn.sock'
# unicornのプロセスIDを保存するファイルを指定
pid '/var/www/app/tmp/pids/unicorn.pid'

# unicornのエラログー・出力ログを標準エラー・標準出力に吐き出す。標準出力→CloudWatchへ
stderr_path = $stderr
stdout_path = $stdout

# ワーカープロセスが処理を開始し終了するまでの最大時間。この設定時間を超えるとワーカーは破棄される。
timeout 60


preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

# フォーク前の処理
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    # unicornとActiveRecord（データベース）との接続を切断する。
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end
  # マスタープロセスの再起動（古いunicornのpidをkill処理し、新しいpidを生成）
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

# フォーク後の処理
after_fork do |_server, _worker|
  # unicornとActiveRecord（データベース）との再接続を行う。
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
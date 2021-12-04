require Rails.root.join('config', 'environments', 'production')
 
# 環境（ここでは本番環境）ごとにアプリケーションのログを出力する。
Rails.application.configure do
  # デバック以上のログのみを抽出
  config.log_level = :debug
  # 標準出力としてアプリケーションのログを出力
  config.logger = Logger.new(STDOUT)
end
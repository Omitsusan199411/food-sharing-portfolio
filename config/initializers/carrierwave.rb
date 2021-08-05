require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.prd?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = ENV['AWS_S3_BUCKET_NAME']
    config.asset_host = ENV['AWS_S3_ASSET_HOST']
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: 'ap-northeast-1',
      path_style: true
    }
  else
    # 開発環境:public/uploades下に保存
    config.storage :file
    #test:処理をスキップ
    config.enable_processing = false if Rails.env.test?
  end
end
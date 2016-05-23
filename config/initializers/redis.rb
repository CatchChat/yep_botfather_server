redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: ENV['REDIS_DB'], driver: ENV['REDIS_DRIVER'])
Redis.current = Redis::Namespace.new(ENV['REDIS_NAMESPACE'], redis: redis)

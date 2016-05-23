module YepBot
  class App < Server
    def initialize
      YepBot.configure do |config|
        config.bot_id = ENV['YEP_BOT_ID'] || raise("Missing ENV['YEP_BOT_ID'].")
        config.token = ENV['YEP_API_TOKEN'] || raise("Missing ENV['YEP_API_TOKEN'].")
      end
      YepApi.configure do |config|
        config.token = YepBot.config.token
      end
      super
    end

    def config
      YepBot.config
    end

    def self.instance
      @instance ||= new
    end
  end
end

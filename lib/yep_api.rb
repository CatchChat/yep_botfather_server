module YepApi
  autoload :Config,     'yep_api/config.rb'
  autoload :Base,       'yep_api/base.rb'
  autoload :Response,   'yep_api/response.rb'
  autoload :Attachment, 'yep_api/attachment.rb'
  autoload :Bot,        'yep_api/bot.rb'
  autoload :Message,    'yep_api/message.rb'

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end

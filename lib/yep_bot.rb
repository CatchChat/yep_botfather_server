module YepBot
  autoload :Config,         'yep_bot/config.rb'
  autoload :Command,        'yep_bot/command.rb'
  autoload :Server,         'yep_bot/server.rb'
  autoload :App,            'yep_bot/app.rb'
  autoload :Message,        'yep_bot/message.rb'
  autoload :MessageHandler, 'yep_bot/message_handler.rb'
  autoload :Loggable,       'yep_bot/support/loggable.rb'

  module Objects
    autoload :User,    'yep_bot/objects/user.rb'
    autoload :Message, 'yep_bot/objects/message.rb'
  end

  module Commands
    autoload :Base,            'yep_bot/commands/base.rb'
    autoload :Cancel,          'yep_bot/commands/cancel.rb'
    autoload :DeleteBot,       'yep_bot/commands/delete_bot.rb'
    autoload :Help,            'yep_bot/commands/help.rb'
    autoload :NewBot,          'yep_bot/commands/new_bot.rb'
    autoload :Revoke,          'yep_bot/commands/revoke.rb'
    autoload :SetAvatar,       'yep_bot/commands/set_avatar.rb'
    autoload :SetIntroduction, 'yep_bot/commands/set_introduction.rb'
    autoload :SetNickname,     'yep_bot/commands/set_nickname.rb'
    autoload :Token,           'yep_bot/commands/token.rb'
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end

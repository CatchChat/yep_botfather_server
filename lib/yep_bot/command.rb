module YepBot
  class Command
    class << self
      def get_command_from(message)
        text = message.text_content.to_s.strip
        command_class = case message.sender.command
                        when 'NewBot'
                          YepBot::Commands::NewBot
                        when 'Cancel'
                          YepBot::Commands::Cancel
                        when 'DeleteBot'
                          YepBot::Commands::DeleteBot
                        when 'Revoke'
                          YepBot::Commands::Revoke
                        when 'SetAvatar'
                          YepBot::Commands::SetAvatar
                        when 'SetIntroduction'
                          YepBot::Commands::SetIntroduction
                        when 'SetNickname'
                          YepBot::Commands::SetNickname
                        when 'Token'
                          YepBot::Commands::Token
                        else
                          commands.detect { |cmd| cmd.match?(text) }
                        end

        (command_class || YepBot::Commands::Help).new(message)
      end

      def commands
        [
          YepBot::Commands::NewBot,
          YepBot::Commands::SetAvatar,
          YepBot::Commands::SetIntroduction,
          YepBot::Commands::SetNickname,
          YepBot::Commands::Token,
          YepBot::Commands::Revoke,
          YepBot::Commands::Cancel,
          YepBot::Commands::DeleteBot
        ]
      end
    end
  end
end

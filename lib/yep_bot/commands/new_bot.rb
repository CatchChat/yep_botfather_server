module YepBot
  module Commands
    class NewBot < Base
      command '/newbot'
      title '/newbot'
      desc 'create a new bot'

      def invoke
        sender  = @message.sender
        if sender.command == 'NewBot'
          text = @message.text_content.to_s.strip
          if nickname = sender.arguments[0]
            username = text
            if username.empty?
              say_username_is_invalid
            else
              new_bot(sender, nickname, username)
            end
          else
            nickname = text
            if nickname.empty?
              say_is_not_proper_nickname
            else
              sender.push_argument(nickname)
              say_set_username
            end
          end
        else
          sender.command = 'NewBot'
          say_set_nickname
        end
      end

      private

      def new_bot(sender, nickname, username)
        response = YepApi::Bot.create(sender.id, nickname, username)
        if response.success?
          say_new_bot_done(response.body['token'])
          sender.cancel_command
        else
          say "Sorry, #{response.error}"
        end
      end

      def say_set_nickname
        say 'Alright, a new bot. How are we going to call it? Please choose a nickname for your bot.'
      end

      def say_set_username
        say "Good. Now let's choose a username for your bot. It must end in `bot`. Like this, for example: sayhi_bot."
      end

      def say_new_bot_done(token)
        say <<-TEXT
Done! Congratulations on your new bot. You can now add a description, profile picture for your bot, see /help for a list of commands.

Use this token to access the HTTP API:
#{token}
        TEXT
      end

      def say_is_not_proper_nickname
        say "Sorry, this isn't a proper nickname for a bot."
      end
    end
  end
end

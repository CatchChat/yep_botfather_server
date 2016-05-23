module YepBot
  module Commands
    class SetNickname < Base
      command '/set_nickname'
      title '/set_nickname'
      desc 'change bot nickname'

      def invoke
        sender = @message.sender
        if sender.command == 'SetNickname'
          if username = sender.arguments[0]
            nickname = @message.text_content.to_s.strip
            if nickname.empty?
              say_is_not_proper_nickname
            else
              set_nickname(username, nickname)
            end
          else
            choose_a_bot { say_input_nickname }
          end
        else
          sender.command = 'SetNickname'
          say_choose_a_bot('Choose a bot to change nickname.')
        end
      end

      private

      def set_nickname(username, nickname)
        response = YepApi::Bot.set_nickname(username, nickname)
        if response.success?
          say 'Success! Nickname updated. /help'
          @message.sender.cancel_command
        else
          say "Sorry, #{response.error}."
        end
      end

      def say_is_not_proper_nickname
        say "Sorry, this isn't a proper nickname for a bot."
      end

      def say_input_nickname
        say 'OK. Send me the new nickname for your bot.'
      end
    end
  end
end

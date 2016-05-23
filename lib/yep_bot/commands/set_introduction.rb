module YepBot
  module Commands
    class SetIntroduction < Base
      command '/set_introduction'
      title '/set_introduction'
      desc 'change bot introduction'

      def invoke
        sender = @message.sender
        if sender.command == 'SetIntroduction'
          if username = sender.arguments[0]
            introduction = @message.text_content.to_s
            if introduction.empty?
              say_introduction_is_invalid
            else
              set_introduction(username, introduction)
            end
          else
            choose_a_bot { say_input_introduction }
          end
        else
          sender.command = 'SetIntroduction'
          say_choose_a_bot('Choose a bot to change introduction.')
        end
      end

      private

      def set_introduction(username, introduction)
        response = YepApi::Bot.set_introduction(username, introduction)
        if response.success?
          say 'Success! Introduction updated. /help'
          @message.sender.cancel_command
        else
          say "Sorry, #{response.error}."
        end
      end

      def say_introduction_is_invalid
        say 'Sorry, the introduction is invalid.'
      end

      def say_input_introduction
        say "OK. Send me the new introduction for the bot. People will see this introduction when they open a chat with your bot, in a block titled 'What can this bot do?'."
      end
    end
  end
end

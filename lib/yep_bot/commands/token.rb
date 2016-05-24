module YepBot
  module Commands
    class Token < Base
      command '/token'
      title '/token'
      desc 'get access token'

      def invoke
        sender = @message.sender
        if sender.command == 'Token'
          if username = get_username(@message.text_content.to_s.strip)
            get_token(username)
          else
            say_username_is_invalid
          end
        else
          sender.command = 'Token'
          say_choose_a_bot('Choose a bot to get access token.')
        end
      end

      private

      def get_token(username)
        response = YepApi::Bot.token(username)
        if response.success?
          say <<-TEXT
You can use this token to access HTTP API:
#{response.body['token']}
          TEXT
          @message.sender.cancel_command
        else
          say "Sorry, #{response.error}."
        end
      end
    end
  end
end

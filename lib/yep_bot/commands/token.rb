module YepBot
  module Commands
    class Token < Base
      command '/token'
      title '/token'
      desc 'get access token'

      def invoke
        sender = @message.sender
        if sender.command == 'Token'
          username = @message.text_content.to_s.strip
          if username.empty?
            say_username_is_invalid
          else
            get_token(username)
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
        else
          say "Sorry, #{response.error}."
        end
      end
    end
  end
end

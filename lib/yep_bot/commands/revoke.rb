module YepBot
  module Commands
    class Revoke < Base
      command '/revoke'
      title '/revoke'
      desc 'revoke bot access token'

      def invoke
        sender = @message.sender
        if sender.command == 'Revoke'
          if username = get_username(@message.text_content.to_s.strip)
            revoke_token(username)
          else
            say_username_is_invalid
          end
        else
          sender.command = 'Revoke'
          say_choose_a_bot('Choose a bot to generate a new token. Warning: your old token will stop working.')
        end
      end

      private

      def revoke_token(username)
        response = YepApi::Bot.revoke_token(username)
        if response.success?
          say <<-TEXT
Your token was replaced with a new one. You can use this token to access HTTP API:
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

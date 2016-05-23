module YepBot
  module Commands
    class SetAvatar < Base
      command '/set_avatar'
      title '/set_avatar'
      desc 'change bot profile photo'

      def invoke
        sender = @message.sender
        if sender.command == 'SetAvatar'
          if username = sender.arguments[0]
            avatar_url = @message.attachments[0]['file']['url'] rescue nil
            if avatar_url
              set_avatar(username, avatar_url)
            else
              say_send_a_photo
            end
          else
            choose_a_bot { say_input_avatar }
          end
        else
          sender.command = 'SetAvatar'
          say_choose_a_bot('Choose a bot to change profile photo.')
        end
      end

      private

      def set_avatar(username, avatar_url)
        response = YepApi::Bot.set_avatar(username, avatar_url)
        if response.success?
          say 'Success! Profile photo updated. /help'
          @message.sender.cancel_command
        else
          say "Sorry, #{response.error}."
        end
      end

      def say_send_a_photo
        say "Please send a photo."
      end

      def say_input_avatar
        say 'OK. Send me the new profile photo for the bot.'
      end
    end
  end
end

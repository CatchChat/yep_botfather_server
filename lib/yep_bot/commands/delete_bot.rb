module YepBot
  module Commands
    class DeleteBot < Base
      command '/deletebot'
      title '/deletebot'
      desc 'delete a bot'

      def invoke
        sender = @message.sender
        if sender.command == 'DeleteBot'
          text = @message.text_content.to_s.strip
          if username = sender.arguments[0]
            if text == confirmation_text
              delete_bot(username)
            else
              say_confirmation_or_cancel
            end
          else
            choose_a_bot { say_confirmation(get_username(text)) }
          end
        else
          sender.command = 'DeleteBot'
          say_choose_a_bot('Choose a bot to delete.')
        end
      end

      private

      def delete_bot(username)
        response = YepApi::Bot.destroy(username)
        if response.success?
          say 'Done! The bot is gone. /help'
          @message.sender.cancel_command
        else
          say "Sorry, #{response.error}, please choose a existing bot."
          @message.sender.pop_argument
        end
      end

      def say_confirmation(username)
        say <<-TEXT
OK, you selected @#{username}. Are you sure?

Send '#{confirmation_text}' to confirm you really want to delete this bot.
        TEXT
      end

      def say_confirmation_or_cancel
        say <<-TEXT
Please enter the confirmation text exactly like this:
#{confirmation_text}

Type /cancel to cancel the opearation.
        TEXT
      end

      def confirmation_text
        'Yes, I am totally sure.'
      end
    end
  end
end

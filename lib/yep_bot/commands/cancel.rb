module YepBot
  module Commands
    class Cancel < Base
      command '/cancel'
      title '/cancel'
      desc 'cancel the current operation'

      def invoke
        sender = @message.sender
        if sender.command
          say <<-TEXT
The command #{command} has been cancelled. Anything else I can do for you?

Send /help for a list of commands.
          TEXT
        else
          say "No active command to cancel. I wasn't doing anything anyway. Zzzzz..."
        end
        sender.cancel_command
      end
    end
  end
end

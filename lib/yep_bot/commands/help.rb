module YepBot
  module Commands
    class Help < Base
      def invoke
        @message.sender.cancel_command
        say <<-TEXT
They call me the BotFather, I can help you create and set up Yep bots.

You can control me by sending these commands:

#{YepBot::Command.commands.map { |cmd| "#{cmd.command_title} - #{cmd.command_desc}" }.join("\n")}
        TEXT
      end
    end
  end
end

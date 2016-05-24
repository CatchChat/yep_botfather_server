module YepBot
  module Commands
    class Base
      include Loggable

      class << self
        def inherited(subclass)
          subclass.instance_eval do
            attr_accessor :title, :desc, :command
          end
        end

        def title(title)
          @title = title
        end

        def desc(desc)
          @desc = desc
        end

        def command_title
          @title
        end

        def command_desc
          @desc
        end

        def command(expression)
          @command = expression
        end

        def match?(text)
          case @command
          when String
            text == @command
          when Regexp
            text =~ @command
          else false
          end
        end
      end

      def initialize(message)
        @message = message
      end

      private

      def choose_a_bot(&block)
        username = get_username(@message.text_content.to_s.strip)
        if username.empty?
          say_username_is_invalid
        elsif bot_exist?(username)
          @message.sender.push_argument(username)
          block.call if block_given?
        else
          say_bot_is_not_found(username)
        end
      end

      def get_username(text)
        return text if text !~ /\A\d+\z/
        @message.sender.bots[text.to_i - 1]
      end

      def bot_exist?(username)
        response = YepApi::Bot.check_exist(username)
        response.body['exist']
      end

      def say(text)
        logger.debug "say to <#{@message.sender.id}|#{@message.sender.nickname}>:\n#{text}"
        YepApi::Message.create('User', @message.sender.id, text_content: text)
      end

      def say_choose_a_bot(text)
        response = YepApi::Bot.index(@message.sender.id)
        if response.success?
          usernames = response.body['bots'].map { |bot| bot['username'] }
          if usernames.empty?
            say "You don't have any bots yet. Use the /newbot command to create a new bot first."
            @message.sender.cancel_command
          else
            usernames_text = usernames.map.with_index do |username, index|
              "#{index + 1}. #{username}"
            end.join("\n")
            say <<-TEXT
#{text}

All bots:

#{usernames_text}

You can type a username or a number.
            TEXT
          end
        else
          say 'Sorry, the bot some errors occurred, please try again later.'
        end
      end

      def say_bot_is_not_found(username)
        say "Sorry, the #{username} bot is not found, please choose a existing bot."
      end

      def say_username_is_invalid
        say 'Sorry, this username is invalid.'
      end
    end
  end
end

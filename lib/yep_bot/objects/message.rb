module YepBot
  module Objects
    class Message
      def initialize(message)
        @message = message
      end

      %w(id recipient_id recipient_type text_content attachments).each do |method_name|
        define_method method_name do
          @message[method_name]
        end
      end

      def sender
        return @sender if defined? @sender
        @sender = User.new(@message['sender'])
      end

      def direct_message?
        recipient_type == 'User'
      end

      def group_message?
        recipient_type == 'Circle'
      end

      def self_message?
        sender.id == YepBot.config.bot_id
      end

      def mark_as_read
        if direct_message?
          recipient_type = self.recipient_type
          recipient_id   = sender.id
        elsif group_message?
          recipient_type = self.recipient_type
          recipient_id   = self.recipient_id
        end

        YepApi::Message.mark_as_read(recipient_type, recipient_id, id)
      end

      def build_typing_reply
        if direct_message?
          recipient_type = self.recipient_type
          recipient_id   = sender.id
        elsif group_message?
          recipient_type = self.recipient_type
          recipient_id   = self.recipient_id
        end

        Faye.to_json(
          message_type: 'instant_state',
          message: {
            state: 0,
            recipient_type: recipient_type,
            recipient_id: recipient_id
          }
        )
      end

      def reply(&block)
        return if self_message?
        mark_as_read
        block.call
      end
    end
  end
end

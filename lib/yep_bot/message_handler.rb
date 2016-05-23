module YepBot
  class MessageHandler
    include Loggable

    def self.handle(data, client)
      json = MultiJson.load(data)
      if json['message_type'] != 'message'
        logger.info "message_type is not message, data: #{data}"
        return
      end

      message = Objects::Message.new(json['message'])
      if message.self_message?
        logger.info "message is self message, data: #{data}"
        return
      end

      if message.group_message?
        logger.info "message is group message, data: #{data}"
        return
      end

      logger.debug message.text_content
      message.reply do
        command_wait = rand(3) + 1
        typing_message = message.build_typing_reply
        timer = EM.add_periodic_timer(0.9) { client.send typing_message }
        EM.add_timer(command_wait) { timer.cancel; YepBot::Command.get_command_from(message).invoke }
      end
    end
  end
end

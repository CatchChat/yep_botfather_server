module YepBot
  module Config
    extend self

    ATTRS = [:bot_id, :token].freeze
    attr_accessor(*ATTRS)

    def reset!
      ATTRS.each { |attr| send("#{attr}=", nil) }
    end
  end
end

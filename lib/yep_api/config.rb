module YepApi
  module Config
    extend self

    ATTRS = [:token].freeze
    attr_accessor :token

    def reset!
      ATTRS.each { |attr| send("#{attr}=", nil) }
    end
  end
end

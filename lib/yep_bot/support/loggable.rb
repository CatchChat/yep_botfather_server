module YepBot
  module Loggable
    def self.included(base)
      base.instance_eval do
        def logger
          @logger ||= begin
            $stdout.sync = true
            Logger.new(STDOUT)
          end
        end
      end
    end

    private

    def logger
      self.class.logger
    end
  end
end

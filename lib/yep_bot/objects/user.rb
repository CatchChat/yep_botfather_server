module YepBot
  module Objects
    class User
      def initialize(user)
        @user = user
      end

      %w(id nickname username).each do |method_name|
        define_method method_name do
          @user[method_name]
        end
      end

      def command
        input_list[0]
      end

      def command=(command)
        cancel_command
        input_list << command
        Redis.current.rpush(redis_input_list_key, command)
      end

      def push_argument(argument)
        return unless input_list[0]

        input_list << argument
        Redis.current.rpush(redis_input_list_key, argument)
      end

      def pop_argument
        return if arguments.empty?

        input_list.pop
        Redis.current.rpop(redis_input_list_key)
      end

      def arguments
        input_list[1..-1]
      end

      def cancel_command
        @input_list = []
        Redis.current.del(redis_input_list_key)
      end

      private

      def input_list
        @input_list if defined? @input_list
        @input_list = Redis.current.lrange(redis_input_list_key, 0, -1)
      end

      def redis_input_list_key
        "#{id}:input_list"
      end
    end
  end
end

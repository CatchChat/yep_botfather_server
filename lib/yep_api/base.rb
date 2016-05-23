module YepApi
  class Base
    class HTTPMethodError < StandardError; end

    class << self
      def send_request(http_method, path, headers: {}, body: nil)
        RestClient.send(*generate_request_arguments(http_method, path, headers: headers, body: body)) do |response|
          YepApi::Response.new(response)
        end
      rescue Errno::ETIMEDOUT
        YepApi::Response.new(nil, 'Service Unavailable')
      end

      private

      def generate_request_arguments(http_method, path, headers: {}, body: nil)
        headers['Content-Type']  = 'application/json'
        headers['Authorization'] = "Token token=\"#{ENV['YEP_API_TOKEN']}\""
        case http_method.to_sym
        when :get, :head, :delete, :options
          [http_method.to_sym, "#{ENV['YEP_API_BASE_URL']}#{path}", headers.merge(params: body)]
        when :put, :post, :patch
          [http_method.to_sym, "#{ENV['YEP_API_BASE_URL']}#{path}", body, headers]
        else
          fail HTTPMethodError, "#{http_method.to_s} is invalid"
        end
      end
    end
  end
end

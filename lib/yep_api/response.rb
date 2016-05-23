module YepApi
  class Response
    def initialize(response, error = nil)
      @response = response
      @error    = error
    end

    def success?
      @error.nil? && (200...300).include?(@response.code)
    end

    def body
      return @response_body if defined?(@response_body)
      @response_body = @response.body.empty? ? nil : JSON.parse(@response.body)
    end

    def error
      @error || body['error']
    end
  end
end

module YepApi
  class Attachment < Base
    class << self
      def create(file, metadata)
        send_request(:post, '/attachments', body: { file: file, metadata: metadata, attachable_type: 'Message' })
      end
    end
  end
end

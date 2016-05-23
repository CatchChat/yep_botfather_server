module YepApi
  class Message < Base
    class << self
      def create(recipient_type, recipient_id, media_type: 'text', attachment_id: nil, text_content: nil, parent_id: nil, longitude: nil, latitude: nil)
        send_request(:post, "/#{recipient_type}/#{recipient_id}/messages", body: {
          media_type: media_type,
          attachment_id: attachment_id,
          text_content: text_content,
          parent_id: parent_id,
          longitude: longitude,
          latitude: latitude
        })
      end

      def mark_as_read(recipient_type, recipient_id, max_id)
        send_request(
          :patch,
          "/#{recipient_type}/#{recipient_id}/messages/batch_mark_as_read",
          body: { max_id: max_id }
        )
      end
    end
  end
end

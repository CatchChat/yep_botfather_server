module YepApi
  class Bot < Base
    class << self
      def index(user_id)
        send_request(:get, "/users/#{user_id}/bots")
      end

      def create(user_id, nickname, username, x_forworded_for = nil)
        headers = {}
        headers['X-Forworded-For'] = x_forworded_for if x_forworded_for
        send_request(:post, '/bots', headers: headers, body: { user_id: user_id, nickname: nickname, username: username })
      end

      def destroy(username)
        send_request(:delete, "/bots/#{username}")
      end

      def check_exist(username)
        send_request(:get, "/bots/check_exist", body: { username: username })
      end

      def set_introduction(username, introduction)
        send_request(:patch, "/bots/#{username}/set_introduction", body: { introduction: introduction })
      end

      def set_nickname(username, nickname)
        send_request(:patch, "/bots/#{username}/set_nickname", body: { nickname: nickname })
      end

      def set_avatar(username, avatar_url)
        send_request(:patch, "/bots/#{username}/set_avatar", body: { avatar_url: avatar_url })
      end

      def token(username)
        send_request(:get, "/bots/#{username}/token")
      end

      def revoke_token(username)
        send_request(:patch, "/bots/#{username}/revoke_token")
      end
    end
  end
end

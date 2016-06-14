module YepBot
  class Server
    include Loggable
    TRAPPED_SIGNALS = %w(INT TERM).freeze

    def start!
      @stopping = false
      handle_signals
      run!
    end

    def stop!
      @stopping = true
    end

    private

    def handle_signals
      TRAPPED_SIGNALS.each do |signal|
        Signal.trap(signal) do
          logger.info 'stopping...'
          stop!
          sleep 1
          exit
        end
      end
    end

    def websocket_url
      "#{ENV['YEP_WEBSOCKET_BASE_URL']}/#{YepBot.config.bot_id}:#{YepBot.config.token}"
    end

    def run!
      EM.run {
        reconnect_times = 0
        reconnect = connect = lambda do
          ws = Faye::WebSocket::Client.new(websocket_url, [], extensions: [PermessageDeflate], ping: 10)

          ws.on :open do |event|
            logger.info "connected #{websocket_url}"
            reconnect_times = 0
          end

          ws.on :message do |event|
            YepBot::MessageHandler.handle(event.data, ws)
          end

          ws.on :close do |event|
            logger.info [:close, event.code, event.reason]
            ws = nil
            EM.stop if event.code == 4030
            EM.add_timer([reconnect_times * 2, 60].min) {
              logger.info "reconnecting #{websocket_url}"
              reconnect_times += 1
              reconnect.call
            }
          end

          EM.add_periodic_timer(1) {
            if @stopping
              ws.close
              EM.stop
            end
          }
        end

        connect.call
      }
    end
  end
end

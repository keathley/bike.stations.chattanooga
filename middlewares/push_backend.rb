require 'faye/websocket'

module BikeStationsChattanooga
  class PushBackend
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @client = []
    end

    def call(env)
    end
  end
end

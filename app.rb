require 'net/http'
require 'uri'
require 'json'
require 'sinatra'
require 'sinatra/streaming'
require 'rack/cors'
require 'eventmachine'
require 'em-http-request'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/api/stations', :headers => :any
  end
end

get "/" do
  redirect '/index.html'
end

get "/api/stations" do
  content_type :json

  uri = URI.parse("http://www.bikechattanooga.com/stations/json")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  response.body.to_json
end

get "/api/stations/stream", :provides => 'text/event-stream' do
  stream :keep_alive do |out|
    EventMachine::PeriodicTimer.new(10) {
      http = EventMachine::HttpRequest.new(
        'http://www.bikechattanooga.com/stations/json'
      ).get
      http.callback {
        out << "data: #{http.response}\n\n" unless out.closed?
      }
    }
  end
end

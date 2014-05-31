require 'net/http'
require 'uri'
require 'json'
require 'sinatra'
require 'rack/cors'

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

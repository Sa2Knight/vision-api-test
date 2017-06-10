require 'net/http'
require 'base64'
require 'json'

class Client

  @@API_KEY = ENV['GOOGLEAPI']
  @@API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{@@API_KEY}"

  def initialize(params)
    @params  = params
  end

  def get_result
    to_base64(@params['file'])
  end

  private

  def to_base64(file)
    binary = file['tempfile'].read
    Base64.encode64(binary)
  end

  def post(params = {})
    uri  = URI.parse(@@API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    req.body = JSON.generate(params)
    res = http.request(req)
    res.body
  end

end

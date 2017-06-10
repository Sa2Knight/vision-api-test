require 'net/http'
require 'base64'
require 'json'

class Client

  @@API_KEY = ENV['GOOGLEAPI']
  @@API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{@@API_KEY}"

  def initialize(params)
    @params  = params
    @file    = params['file']['tempfile'].read
  end

  def get_result
    landmark_detection
  end

  def landmark_detection
    params = create_params('LANDMARK_DETECTION')
    post(params)
  end

  private

  def create_params(type)
    {
      :requests => [
        {
          :image => {
            :content => Base64.strict_encode64(@file),
          },
          :features => [
            :type => type,
            :maxResults => 1,
          ]
        },
      ],
    }
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

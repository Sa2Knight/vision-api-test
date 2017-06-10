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

  def landmark_detection
    params = create_params('LANDMARK_DETECTION')
    result = post(params)
    result['responses'][0].empty? and return false
    return result['responses'][0]['landmarkAnnotations'][0]
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
    JSON.parse(res.body)
  end

end

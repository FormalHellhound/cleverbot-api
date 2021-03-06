require 'rest-client'
require 'json'

class Cleverbot
  URL = 'https://www.cleverbot.com/getreply'.freeze

  ERRORS = {
    401 => 'Cleverbot API key not valid',
    404 => 'Cleverbot API not found',
    413 => 'Cleverbot API request too large. Please limit requests to 8KB',
    502 => 'Unable to get reply from API server, please contact Cleverbot Support',
    503 => 'Cleverbot API: Too many requests from client',
    504 => 'Unable to get reply from API server, please contact Cleverbot Support'
  }.freeze

  def initialize(apikey)
    @api_url = "#{URL}?key=#{apikey}&wrapper=ruby-cleverbot-api"
    @cs = ''
  end

  def make_get(url)
    # RestClient.post url, message
    RestClient.get(url) { |response| response }
  end

  def send_message(message)
    enc_cs = CGI.escape(@cs)
    enc_message = CGI.escape(message.strip)
    url = "#{@api_url}&input=#{enc_message}&cs=#{enc_cs}"
    response = make_get(url)
    puts ERRORS[response.code] if ERRORS.key?(response.code)
    clever_response = JSON.parse(response)
    @cs = clever_response['cs']
    clever_response['output']
  end

  def reset
    @cs = ''
  end
end

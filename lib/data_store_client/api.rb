require 'i18n'
require 'typhoeus'

module DataStoreClient::Api
  class RequestError < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def status
      if response_code == 0
        503
      else
        response_code
      end
    end

    def to_s
      "(#{response_code}) #{response.body}"
    end

    private

    def response_code
      if response.respond_to?(:response_code)
        response.response_code
      else
        response.code
      end
    end
  end

  def self.request(verb, path, options)
    response = request_raw(verb, path, options)
    raise RequestError.new(response) unless response.success?
    ActiveSupport::JSON.decode(response.body)
  end

  def self.request_raw(verb, path, options)
    options.symbolize_keys!
    url = File.join(DataStoreClient.base_url, build_path(path, options))
    verb = verb.to_sym
    Typhoeus::Request.send(verb, url, request_options(verb, options))
  end

  private

  def self.build_path(path, options)
    options.keys.each do |key|
      path.gsub!(":#{key}", options[key].to_s)
    end
    path
  end

  def self.request_options(verb, options)
    result = {}
    version = options.delete(:version) || DataStoreClient::DEFAULT_API_VERSION

    if verb.to_sym == :get
      result[:params] = options
    else
      result[:body] = options.to_json
    end

    if DataStoreClient.disable_ssl
      result[:ssl_verifyhost] = 0
      result[:ssl_verifypeer] = false
    end

    result[:headers] = {
      'Accept' => "application/vnd.paid-media-v#{version}+json",
      'Content-Type' => 'application/json',
      'X-Vitrue-Api-Key' => DataStoreClient.api_key,
      'X-VITRUE-User-Id' => options.delete(:user_id)
    }

    result
  end
end

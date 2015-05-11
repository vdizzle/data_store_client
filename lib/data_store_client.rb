require 'active_support/all'
require 'data_store_client/version'
require "data_store_client/api"

module DataStoreClient
  DEFAULT_API_VERSION = 1

  mattr_accessor :base_url, :api_key, :disable_ssl

  def self.initialize_with_file!(path, env = ENV['RACK_ENV'] || ENV['RAILS_ENV'])
    initialize_with_config!(YAML.load(ERB.new(File.read(path)).result).fetch(env))
  end

  def self.initialize_with_config!(options = {})
    options = options.with_indifferent_access
    self.base_url = options.fetch(:base_url)
    self.api_key = options.fetch(:api_key)
    self.disable_ssl = options[:disable_ssl]
  end
end

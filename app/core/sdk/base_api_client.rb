require 'faraday_middleware'

module Sdk
  class BaseApiClient
    attr_reader :config
    attr_accessor :url_params

    def initialize
      @config = RecursiveOpenStruct.new(config_class::DATA)
    end

    def method_missing(method_name, *args, &block)
      endpoint = config.endpoints.send(method_name)
      return super unless endpoint
      url = endpoint.url.respond_to?(:call) ? endpoint.url.call(url_params) : endpoint.url
      log("url #{base_uri}#{url}, request #{args}", method_name)
      params, headers = parse_args(*args)
      resp = @conn.send(endpoint.type) do |req|
        req.url url
        req.body = params if endpoint.type == 'post'
        params.each { |key, value| req.params[key] = value.to_s } if endpoint.type == 'get'
        headers.each { |key, value| req.headers[key] = value.to_s }
      end
      log("url #{base_uri}#{url}, response #{resp.body.truncate(300)}", method_name)

      return self.send(:response_handler, resp) if self.respond_to?(:response_handler)

      begin
        OpenStruct.new({ body: JSON.parse(resp.body), status: resp.status })
      rescue
        OpenStruct.new({ body: resp.body, status: resp.status })
      end
    end

    def parse_args(params = {}, headers = {})
      [params, headers]
    end

    def respond_to_missing?(method_name, include_private = false)
      config.endpoints.send(method_name) || super
    end

    def log(message, endpoint)
      Rails.logger.send(log_level, "[#{self.class.name}][#{endpoint}] #{message}")
    end

    def log_level
      config.log_level || 'debug'
    end

    def config_class
      arr_class = self.class.name.split('::')
      arr_class.pop
      @config_class ||= "#{arr_class.join('::')}::Config".constantize
    rescue NameError
      return false
    end

    def base_uri
      @base_uri || config.base_uri
    end
  end
end

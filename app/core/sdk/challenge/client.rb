module Sdk
  module Challenge
    class Client < BaseApiClient
      def initialize
        super()
        @conn = Faraday.new(url: base_uri) do |con|
          con.request :json
          con.adapter Faraday.default_adapter

          con.headers['Content-Type'] = 'application/json'
          con.options.timeout = 20
        end
      end
    end
  end
end
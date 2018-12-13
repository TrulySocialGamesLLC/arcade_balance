module Sdk
  module Arcade
    module Config
      DATA = {
        base_uri: ENV['ARCADE_SERVER_URL'] || 'http://arcade',
        log_level: 'warn',
        endpoints: {
          period_key_for_challenge: {
            type: 'get',
            url: '/challenges/period_key'
          }
        }
      }.freeze
    end
  end
end

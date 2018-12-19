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
          },
          give_reward: {
            type: 'post',
            url: '/winners/give_reward'
          }
        }
      }.freeze
    end
  end
end

module Sdk
  module Challenge
    module Config
      DATA = {
        base_uri: ENV['CHALLENGE_SERVER_URL'] || 'http://challenge',
        log_level: 'warn',
        endpoints: {
          leaderboard_index: {
            type: 'post',
            url: '/leaderboard'
          },
          period_key: {
            type: 'get',
            url: '/challenges/period_key'
          }
        }
      }.freeze
    end
  end
end

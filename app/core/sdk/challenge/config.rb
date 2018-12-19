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
          }
        }
      }.freeze
    end
  end
end

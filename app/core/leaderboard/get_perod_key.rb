module Leaderboard
  class GetPeriodKey  < Rectify::Command
    attr_reader :date, :challenge_id, :type

    def initialize(date, challenge_id, type)
      @date = date
      @challenge_id = challenge_id
      @type = type
    end

    def call
      format_date = date.strftime('%FT%TZ')
      arcade_client = Sdk::Arcade::Client.new
      arcade_response = arcade_client.period_key_for_challenge(datetime: format_date, challenge_id: challenge_id)
      arcade_response.body[type]
    end
  end
end
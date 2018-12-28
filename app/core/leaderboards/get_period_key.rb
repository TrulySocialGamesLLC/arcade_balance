module Leaderboards
  class GetPeriodKey  < Rectify::Command
    attr_reader :date, :challenge_id

    def initialize(date, challenge_id)
      @date = date
      @challenge_id = challenge_id
    end

    def call
      format_date = date.strftime('%FT%TZ')
      client = Sdk::Challenge::Client.new
      response = client.period_key(datetime: format_date, challenge_id: challenge_id)
      response.body
    end
  end
end
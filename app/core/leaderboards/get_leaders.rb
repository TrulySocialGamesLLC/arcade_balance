module Leaderboards
  class GetLeaders  < Rectify::Command
    attr_reader :period_key, :challenge_id

    def initialize(period_key, challenge_id)
      @period_key = period_key
      @challenge_id = challenge_id
    end

    def call
      challenge_client = Sdk::Challenge::Client.new
      response = challenge_client.leaderboard_index(sections: [{name: "first_place", bound_value: 0, "count": 25}],
                                                    period_key: period_key,
                                                    challenge_id: challenge_id,
                                                    previous_period_at: nil,
                                                    minigame_id: nil)
      response.body
    end
  end
end
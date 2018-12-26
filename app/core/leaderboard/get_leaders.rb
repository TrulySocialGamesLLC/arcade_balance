module Leaderboard
  class GetLeaders  < Rectify::Command
    attr_reader :period_key, :challenge_id, :type

    def initialize(period_key, challenge_id, type)
      @period_key = period_key
      @challenge_id = challenge_id
      @type = type
    end

    def call
      challenge_client = Sdk::Challenge::Client.new
      response = challenge_client.leaderboard_index(sections: [{offset: 0, name: "first_place", count: 25}],
                                                    period_key: period_key,
                                                    challenge_id: challenge_id,
                                                    type: type,
                                                    previous_period_at: nil,
                                                    minigame_id: nil)
      response.body
    end
  end
end
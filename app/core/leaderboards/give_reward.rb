module Leaderboards
  class GiveReward  < Rectify::Command
    attr_reader :user_id, :date, :challenge_id

    def initialize(user_id, date, challenge_id)
      @user_id = user_id
      @date = date
      @challenge_id = challenge_id
    end

    def call
      client = Sdk::Arcade::Client.new
      client.give_reward(user_id: user_id, date: date, challenge_id: challenge_id)
    end
  end
end
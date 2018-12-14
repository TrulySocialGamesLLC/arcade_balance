module Leaderboard
  class GiveReward  < Rectify::Command
    attr_reader :user_id, :date, :challenge_id, :type

    def initialize(user_id, date, challenge_id, type)
      @user_id = user_id
      @date = date
      @challenge_id = challenge_id
      @type = type
    end

    def call
      client = Sdk::Arcade::Client.new
      client.give_reward(user_id: user_id, date: date, challenge_id: challenge_id, type: type)
    end
  end
end
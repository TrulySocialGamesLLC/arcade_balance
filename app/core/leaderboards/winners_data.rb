module Leaderboards
  class WinnersData  < Rectify::Command

    attr_reader :date, :challenge_id

    def initialize(date, challenge_id)
      @date = date
      @challenge_id = challenge_id
    end

    def call
      period_key = Leaderboards::GetPeriodKey.call(date.to_time(:utc), challenge_id)
      leaderbord_top = Leaderboards::GetLeaders.call(period_key['key'], challenge_id.to_i)

      ch = GqlConfig::Client.parse <<-'GRAPHQL'
          query($id: ID!) {
            challenge(id: $id) {
              id
              type
              extra {
                duration
                winRateLimit
              }
            }
          }
      GRAPHQL
      WinnersData.const_set('Challenge', ch)

      gql_challenge = GqlConfig::Client.query(Challenge, variables: {id: challenge_id.to_i})

      challenge_type = gql_challenge.original_hash["data"]["challenge"]["type"]
      challenge_duration = gql_challenge.original_hash["data"]["challenge"]["extra"]["duration"]
      challenge_limit = gql_challenge.original_hash["data"]["challenge"]["extra"]["winRateLimit"]
      previous_winners_obj = []

      unless period_key.blank?
        end_period = period_key['to'].to_time(:utc)
        previous_winners_obj = Arcade::Winner.where(type: challenge_type, challenge_id: challenge_id)
                                   .where('won_at >= :win_period', win_period: end_period - (challenge_duration * challenge_limit).minutes).pluck(:user_id, :won_at).to_h
      end
      current_winner = Arcade::Winner.current_winner(period_key['key'], challenge_id, challenge_type)
      {
        period_key: period_key['key'],
        leaderbord_top: leaderbord_top,
        previous_winners_obj: previous_winners_obj,
        current_winner: current_winner,
        end_period: end_period,
        type: challenge_type,
      }
    end
  end
end

module Leaderboard
  class WinnersData  < Rectify::Command
    attr_reader :date, :challenge_id, :type

    def initialize(date, challenge_id, type)
      @date = date
      @challenge_id = challenge_id
      @type = type
    end

    def call
      period_key = Leaderboard::GetPeriodKey.call(date.to_time(:utc), challenge_id, type)
      leaderbord_top = Leaderboard::GetLeaders.call(period_key, challenge_id.to_i, type)
      unless period_key.blank?
        end_period = period_key.split('/').last.to_time(:utc)
        previous_winners_obj = Arcade::Winner.where(type: type_to_i(type), challenge_id: challenge_id)
                                   .where('won_at >= :win_period', win_period: end_period - Settings.leaderboard.winner_day_limit.weekly.days).pluck(:user_id, :won_at).to_h
      end
      current_winner = Arcade::Winner.current_winner(period_key, challenge_id, type_to_i(type))
      previous_winners_obj ||= []

      {period_key: period_key, leaderbord_top: leaderbord_top, previous_winners_obj: previous_winners_obj, current_winner: current_winner}
    end

    private

    def type_to_i(type)
      case type
      when 'daily' then 0
      when 'weekly' then 1
      end
    end
  end
end
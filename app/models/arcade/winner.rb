class Arcade::Winner < Arcade::Base
  self.table_name  = :winners
  self.inheritance_column = nil

  belongs_to :user

  def self.current_winner(period_key, challenge_id, type)
    Arcade::Winner.find_by(period_key: period_key, challenge_id: challenge_id, type: type)
  end
end
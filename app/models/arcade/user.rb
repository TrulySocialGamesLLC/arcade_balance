class Arcade::User < Arcade::Base

  def self.table_name
    'users'
  end

  has_many :winners
end
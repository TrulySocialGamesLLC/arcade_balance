class Arcade::Base < ApplicationRecord
  establish_connection(Rails.configuration.database_configuration['default'].merge!(Rails.configuration.database_configuration['arcade']))
end
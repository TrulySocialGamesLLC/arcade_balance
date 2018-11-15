class Arcade::Base < ApplicationRecord
  self.abstract_class = true
  establish_connection(Rails.configuration.database_configuration['default'].merge!(Rails.configuration.database_configuration['arcade']))
end
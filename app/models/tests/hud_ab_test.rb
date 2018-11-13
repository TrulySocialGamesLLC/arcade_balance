class Tests::HudAbTest < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id

end
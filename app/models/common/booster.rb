class Common::Booster < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id, touch: true

  def self.table_name
    'boosters'
  end
  def scope_attributes
    [:name]
  end

end

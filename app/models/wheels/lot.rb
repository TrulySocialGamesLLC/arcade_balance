class Wheels::Lot < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id

  self.inheritance_column = nil

  def scope_attributes
    [:lot_id, :type]
  end

end
class Wheels::Category < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id

  self.inheritance_column = nil

  def scope_attributes
    [:name, :type]
  end

end
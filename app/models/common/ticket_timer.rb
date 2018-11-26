class Common::TicketTimer < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id, touch: true

  def scope_attributes
    [:step]
  end

end
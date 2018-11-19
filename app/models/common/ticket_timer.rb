class Common::TicketTimer < ApplicationRecord

  belongs_to :configuration, class_name: 'Configuration', foreign_key: :configuration_id

  def scope_attributes
    []
  end

end
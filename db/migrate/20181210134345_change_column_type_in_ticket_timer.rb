class ChangeColumnTypeInTicketTimer < ActiveRecord::Migration[5.2]
  def change
    change_column :common_ticket_timers, :time, :float
  end
end

class RenameTicketTimersTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :wheels_ticket_timers, :common_ticket_timers
  end
end

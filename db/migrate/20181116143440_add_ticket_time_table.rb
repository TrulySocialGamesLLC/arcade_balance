class AddTicketTimeTable < ActiveRecord::Migration[5.2]
  def change

    create_table :wheels_ticket_timers do |t|
      t.decimal :time
      t.json    :reward

      t.belongs_to :configuration, index: true, null: false
    end

  end
end

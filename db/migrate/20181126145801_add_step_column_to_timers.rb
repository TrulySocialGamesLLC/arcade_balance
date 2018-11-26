class AddStepColumnToTimers < ActiveRecord::Migration[5.2]
  def change

    change_table :common_ticket_timers do |t|
      t.integer :step
    end

  end
end

class AddEnabledToConfig < ActiveRecord::Migration[5.2]
  def change
    change_table :configurations do |t|
      t.boolean :enabled, default: true
      t.jsonb :initial_data, default: {}
    end
  end
end

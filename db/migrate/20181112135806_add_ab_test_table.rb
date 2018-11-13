class AddAbTestTable < ActiveRecord::Migration[5.2]
  def change

    create_table :tests_hud_ab_tests do |t|
      t.string :scene
      t.string :test

      t.belongs_to :configuration, index: true, null: false
    end

  end
end

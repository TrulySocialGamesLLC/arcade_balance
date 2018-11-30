class FakeMigr < ActiveRecord::Migration[5.2]
  def change
    create_table :fake_table do |t|
      t.string :scene
    end
  end
end

class CreateConfigurationTables < ActiveRecord::Migration[5.2]
  def change

    create_table :configurations do |t|
      t.string :name
      t.string :version

      t.timestamps
    end

    create_table :media_files do |t|
      t.json       :data
      t.belongs_to :owner, polymorphic: true

      t.timestamps
    end

  end
end

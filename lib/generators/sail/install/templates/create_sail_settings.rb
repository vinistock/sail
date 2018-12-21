class CreateSailSettings < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :sail_settings do |t|
      t.string :name, null: false
      t.text :description
      t.string :value, null: false
      t.string :group
      t.integer :cast_type, null: false, limit: 1
      t.timestamps
    end
  end
end

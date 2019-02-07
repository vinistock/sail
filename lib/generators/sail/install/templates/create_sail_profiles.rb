class CreateSailProfiles < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :sail_entries do |t|
      t.string :value, null: false
      t.references :setting, foreign_key: true
      t.references :profile, foreign_key: true
      t.timestamps
    end

    create_table :sail_profiles do |t|
      t.string :name, null: false
      t.index ["name"], name: "index_sail_profiles_on_name", unique: true
      t.timestamps
    end
  end
end

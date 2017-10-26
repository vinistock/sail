class CreateTablesForModels < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :name
      t.integer :value
      t.boolean :real
      t.text :content
    end
  end
end

class AddGroupToSailSettings < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column(:sail_settings, :group, :string)
  end
end

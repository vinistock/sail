class AddActiveToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column(:sail_profiles, :active, :boolean, default: false)
  end
end

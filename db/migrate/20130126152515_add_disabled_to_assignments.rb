class AddDisabledToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :disabled, :boolean, :default => false
  end
end

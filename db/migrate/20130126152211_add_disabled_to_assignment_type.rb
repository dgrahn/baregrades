class AddDisabledToAssignmentType < ActiveRecord::Migration
	def change
		add_column :assignment_types, :disabled, :boolean, :default => false
	end
end

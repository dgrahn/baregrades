class AddDropLowestToAssignmentType < ActiveRecord::Migration
	def change
		add_column :assignment_types, :drop_lowest, :boolean, :default => false
	end
end

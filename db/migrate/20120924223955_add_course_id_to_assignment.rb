class AddCourseIdToAssignment < ActiveRecord::Migration
  def change
	add_column :assignments, :assignment_type_id, :decimal
  end
end

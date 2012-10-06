module AssignmentsHelper
	def manage_grade_path
		if @grade
			link_to "Edit Grade", edit_assignment_grade_path(@assignment)
		else
			link_to "Add Grade", new_assignment_grade_path(@assignment)
		end
	end
end

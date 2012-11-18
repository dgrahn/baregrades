module AssignmentsHelper
	def manage_grade_path(assignment, clas)
		if assignment.user_grade(@current_user).blank?
			link_to "Add Grade", new_assignment_grade_path(assignment), :class => clas
		else
			link_to "Edit Grade", edit_assignment_grade_path(assignment), :class => clas 
		end
	end
end

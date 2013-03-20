module AssignmentsHelper
	#Disables assignment.
	#@param assignment [Assignment]
	#@param current_user [User]
	#@return [boolean] successfully disabled
	def disableAssignment(assignment, current_user)
	
		#update Assignment flag
		assignment_flag = AssignmentFlag.find_by_assignment_id_and_user_id(assignment.id, current_user.id)
		if(assignment_flag.blank?)
			assignment_flag = AssignmentFlag.new
			assignment_flag.user = current_user
			assignment_flag.assignment = assignment
		end
		assignment_flag.disabled = true
		
		#Delete grade
		grade = Grade.find_by_assignment_id_and_user_id(assignment.id, current_user.id)
		if(!grade.blank?)
			grade.destroy
		end
		
		return assignment_flag.save
	end
	#Enables assignment.
	#@param assignment [Assignment]
	#@param current_user [User]
	#@return [boolean] successfully disabled
	def enableAssignment(assignment, current_user)
		assignment_flag = AssignmentFlag.find_by_assignment_id_and_user_id(assignment.id, current_user.id)
		
		if(assignment_flag.blank?)
			assignment_flag = AssignmentFlag.new
			assignment_flag.user = current_user
			assignment_flag.assignment = assignment
		end
		assignment_flag.disabled = false
		
		return assignment_flag.save
	end

end

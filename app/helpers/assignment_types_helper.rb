module AssignmentTypesHelper

	def disableAssignmentType(assignmentType, user)
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignmentType.id, user.id);
		
		# check flag
		if flag.blank?
			# create a flag to disable
			flag = AssignmentTypeFlag.new();
			flag.assignment_type = assignmentType;
			flag.user = user;
			flag.disabled = true;
			
		else
			# change the flag to disable
			flag.disabled = true
		end
		
		return flag.save
	end
	
	def enableAssignmentType(assignmentType, user)
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignmentType.id, user.id);
		
		# check flag
		if flag.blank?
			# create a flag to disable
			flag = AssignmentTypeFlag.new();
			flag.assignment_type = assignmentType;
			flag.user = user;
			flag.disabled = false;
			
		else
			# change the flag to disable
			flag.disabled = false;
		end
		
		return flag.save
	end
end

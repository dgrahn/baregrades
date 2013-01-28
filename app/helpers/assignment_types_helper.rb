module AssignmentTypesHelper

	def disableAssignmentType(assignmentTypeId, userId)
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignmentTypeId, userId);
		
		# check flag
		if flag.blank?
			# create a flag to disable
			flag = AssignmentTypeFlag.new();
			flag.assignment_type = AssignmentType.find(assignmentTypeId);
			flag.user = User.find(userId);
			flag.disabled = true;
			
		else
			# change the flag to disable
			flag.disabled = true
		end
		
		return flag.save
	end
	
	def enableAssignmentType(assignmentTypeId, userId)
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(assignmentTypeId, userId);
		
		# check flag
		if flag.blank?
			# create a flag to disable
			flag = AssignmentTypeFlag.new();
			flag.assignment_type = AssignmentType.find(assignmentTypeId);
			flag.user = User.find(userId);
			flag.disabled = false;
			
		else
			# change the flag to disable
			flag.disabled = false;
		end
		
		return flag.save
	end
end

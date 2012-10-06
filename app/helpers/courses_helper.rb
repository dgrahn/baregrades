module CoursesHelper
	def number_of_students
		studentRoleId = Role.find_by_name("Student").id
		Access.count(:conditions => {:course_id => @course.id, :role_id => studentRoleId});
	end
end

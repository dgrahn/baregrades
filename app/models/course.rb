class Course < ActiveRecord::Base
	attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed

	has_one :grade_scale
	has_many :accesses
	has_many :users, :through => :accesses
	has_many :assignment_types 
	has_many :assignments, :through => :assignment_types 
	

	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		self.assignment_types.each do |type|
			grade = type.user_grade(user)
			if grade
				totalGrade += grade * type.worth
				totalWorth += 100 * type.worth
			end
		end

		if totalWorth != 0
			return  totalGrade / totalWorth * 100
		end
	end
	
	def grade_letter_class(grade)		
		if !grade_scale || !grade
			return 'na'
		elsif grade_scale.a_plus 	&& grade_scale.a_plus 	<= grade
			return 'a plus'
		elsif grade_scale.a 		&& grade_scale.a 		<= grade
			return 'a'
		elsif grade_scale.a_minus 	&& grade_scale.a_minus 	<= grade
			return 'a minus'
		elsif grade_scale.b_plus 	&& grade_scale.b_plus 	<= grade
			return 'b plus'
		elsif grade_scale.b 		&& grade_scale.b 		<= grade
			return 'b'
		elsif grade_scale.b_minus 	&& grade_scale.b_minus 	<= grade
			return 'b minus'
		elsif grade_scale.c_plus 	&& grade_scale.c_plus 	<= grade
			return 'c plus'
		elsif grade_scale.c 		&& grade_scale.c 		<= grade
			return 'c'
		elsif grade_scale.c_minus 	&& grade_scale.c_minus 	<= grade
			return 'c minus'
		elsif grade_scale.d_plus 	&& grade_scale.d_plus 	<= grade
			return 'd plus'
		elsif grade_scale.d 		&& grade_scale.d 		<= grade
			return 'd'
		elsif grade_scale.d_minus 	&& grade_scale.d_minus 	<= grade
			return 'd minus'
		elsif grade_scale.f 		&& grade_scale.f 		<= grade
			return 'F'
		else
			return 'na'
		end
	end
	
	def upcoming_assignments(num_assignments = nil)
		if num_assignments
			return self.assignments
						.where("due_date >= ? AND assignments.id NOT IN (SELECT DISTINCT(assignment_id) FROM grades)", Date.today)
						.order("due_date")
						.limit(num_assignments)
		else
			return self.assignments
						.where("due_date >= ? AND assignments.id NOT IN (SELECT DISTINCT(assignment_id) FROM grades)", Date.today)
						.order("due_date")
		end
	end

	def past_assignments()
		return self.assignments.where("due_date <= ? AND assignments.id NOT IN (SELECT DISTINCT(assignment_id) FROM grades)", Date.today)
	end
	
	def graded_assignments()
		return self.assignments.where("assignments.id IN (SELECT DISTINCT(assignment_id) FROM grades)");
	end

	def undated_assignments()
		return self.assignments.find_all_by_due_date(nil)
	end
end
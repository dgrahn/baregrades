class Course < ActiveRecord::Base
	attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed

	has_one :grade_scale
	has_many :access
	has_many :users, :through => :access
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
			return 'Aplus'
		elsif grade_scale.a 		&& grade_scale.a 		<= grade
			return 'A'
		elsif grade_scale.a_minus 	&& grade_scale.a_minus 	<= grade
			return 'Aminus'
		elsif grade_scale.b_plus 	&& grade_scale.b_plus 	<= grade
			return 'Bplus'
		elsif grade_scale.b 		&& grade_scale.b 		<= grade
			return 'B'
		elsif grade_scale.b_minus 	&& grade_scale.b_minus 	<= grade
			return 'Bminus'
		elsif grade_scale.c_plus 	&& grade_scale.c_plus 	<= grade
			return 'Cplus'
		elsif grade_scale.c 		&& grade_scale.c 		<= grade
			return 'C'
		elsif grade_scale.c_minus 	&& grade_scale.c_minus 	<= grade
			return 'Cminus'
		elsif grade_scale.d_plus 	&& grade_scale.d_plus 	<= grade
			return 'Dplus'
		elsif grade_scale.d 		&& grade_scale.d 		<= grade
			return 'D'
		elsif grade_scale.d_minus 	&& grade_scale.d_minus 	<= grade
			return 'Dminus'
		elsif grade_scale.f 		&& grade_scale.f 		<= grade
			return 'F'
		else
			return 'na'
		end
	end
end
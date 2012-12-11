#   File: course.rb
#  Class: Course
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds all the information for a single course.
# This includes credits, description, identifier, name,
# professor, pin, etc.
# -----------------------------------------------------------

class Course < ActiveRecord::Base
	attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed

	has_one :professor
	has_one :school
	has_one :grade_scale, :dependent => :destroy
	has_many :accesses, :dependent => :destroy
	has_many :users, :through => :accesses
	has_many :assignment_types, :dependent => :destroy
	has_many :assignments, :through => :assignment_types, :dependent => :destroy
	
	# Get the user's grade for a specific assignment type.
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		if(self.points_based)
			self.assignments.each do |assignment|
				grade = assignment.user_grade(user)
				if grade
					totalGrade += grade * 100
					totalWorth += assignment.worth
				end
			end
		else
			self.assignment_types.each do |type|
				grade = type.user_grade(user)
				if grade
					totalGrade += grade * type.worth
					totalWorth += type.worth
				end
			end
		end

		if totalWorth != 0
			return  totalGrade / totalWorth
		end
	end

	def percent_complete(user)
		completedWorth = 0.0
		totalWorth = 0.0
		
		if(self.points_based)
			self.assignments.each do |assignment|
				totalWorth += assignment.worth
				
				if assignment.user_grade(user)
					completedWorth += assignment.worth
				end
			end
		else
			self.assignment_types.each do |type|
				completed = type.percent_complete(user)
				
				if completed != nil
					completedWorth += completed * type.worth
					totalWorth += type.worth
				end
			end
		end
		
		if totalWorth != 0
			return completedWorth / totalWorth
		end
	end
	
	# Get the CSS class for the grade letter.
	def grade_letter_class(grade)		
		if !grade_scale || !grade
			return 'na'
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
		else
			return 'f'
		end
	end
	
	# Get the GPA points for the grade
	def grade_points(user)
		grade = user_grade(user)
		grade = grade_letter_class(grade)

		letter = grade[0..0]
		case letter
			when 'a', points = 4.0
			when 'b', points = 3.0
			when 'c', points = 2.0
			when 'd', points = 1.0
			when 'f', points = 0.0
		end
		
		if grade.include?('plus')
			points += 0.3
		elsif grade.include?('minus')
			points -= 0.3
		end
		
		return points
	end
	
	# Get upcoming assignments.
	def upcoming_assignments(user, num_assignments = nil)
		if num_assignments
			return self.assignments
						.where("due_date >= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
						.order("due_date")
						.limit(num_assignments)
		else
			return self.assignments
						.where("due_date >= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
						.order("due_date")
		end
	end

	# Get past assignments
	def past_assignments(user)
		return self.assignments
						.where("due_date <= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
	end
	
	# Get graded assignments
	def graded_assignments(user)
		return self.assignments
						.where("assignments.id IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)")
	end

	# Get undated assignments
	def undated_assignments(user)
		return self.assignments
						.where("due_date IS NULL AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)")
	end
end
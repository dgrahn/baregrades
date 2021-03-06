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
	attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed, :start_date, :end_date

	belongs_to :professor
	belongs_to :school

	has_one :grade_scale, :dependent => :destroy
	has_many :accesses, :dependent => :destroy
	has_many :users, :through => :accesses
	has_many :assignment_types, :dependent => :destroy
	has_many :assignments, :through => :assignment_types, :dependent => :destroy
	
	validates :name, 		:presence => true
	validates :identifier, 	:presence => true
	validates :credits, 	:presence => true
	
	# Check to make sure a user has a grade
	def has_user_grade?(user)
		self.assignments.each do |assignment|
			if assignment.user_grade(user)
				return true
			end
		end
		
		return false
	end

	# Get the user's grade for a specific assignment type.
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		if(self.points_based)
			self.assignments.each do |assignment|
				grade = assignment.user_grade(user)
				if grade and assignment.worth
					totalGrade += grade * 100
					totalWorth += assignment.worth
				end
			end
		else
			self.assignment_types.each do |type|
				grade = type.user_grade(user)
				if grade and type.worth
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
				
				if completed != nil && type.worth != nil
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
	
	# Get grade letter
	def user_grade_letter(user)
		grade = user_grade(user)
		letter = grade_letter_class(grade)
		letter = letter.gsub(" minus", "-")
		letter = letter.gsub(" plus", "+")
		
		return letter.upcase()
	end
	
	# Get the GPA points for the grade
	def grade_points(user)
		grade = user_grade(user)
		grade = grade_letter_class(grade)

		letter = grade[0..0]
		points = 0
		case letter
			when 'a'
				points = 4.0
			when 'b'
				points = 3.0
			when 'c'
				points = 2.0
			when 'd'
				points = 1.0
			when 'f'
				points = 0.0
		end
		
		puts "=============================================="
		puts letter
		puts points
		puts "=============================================="
		
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
			upcoming_assignments = self.assignments
						.where("due_date >= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
						.order("due_date")
						.limit(num_assignments)
		else
			upcoming_assignments = self.assignments
						.where("due_date >= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
						.order("due_date")
		end
		
		undisabled_upcoming_assignments = Array.new
		
		upcoming_assignments.each do |assignment|
			if(!assignment.is_disabled(user))
				undisabled_upcoming_assignments.push assignment
			end
		end
		
		return undisabled_upcoming_assignments
	end

	# Get past assignments
	def past_assignments(user)
		past_assignments = self.assignments
						.where("due_date <= ? AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)", Date.today)
		
		undisabled_past_assignments = Array.new
		
		past_assignments.each do |assignment|
			if(!assignment.is_disabled(user))
				undisabled_past_assignments.push assignment
			end
		end
		
		return undisabled_past_assignments
	end
	
	# Get disabled assignments
	def disabled_assignments(user)
		disabled_assignments = Array.new
		self.assignments.each do |assignment|		
			if(assignment.is_disabled(user))
				disabled_assignments.push assignment
			end
		end
		return disabled_assignments
	end
	
	# Get graded assignments
	def graded_assignments(user)
		graded_assignments = self.assignments
						.where("assignments.id IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)")
		
		undisabled_graded_assignments = Array.new
		
		graded_assignments.each do |assignment|
			if(!assignment.is_disabled(user))
				undisabled_graded_assignments.push assignment
			end
		end
		
		return undisabled_graded_assignments
	end

	# Get undated assignments
	def undated_assignments(user)
		undated_assignments = self.assignments
						.where("due_date IS NULL AND 
								assignments.id NOT IN (
									SELECT DISTINCT(assignment_id) FROM grades WHERE
										user_id = #{user.id} AND
										grade IS NOT NULL
								)")
		
		undisabled_undated_assignments = Array.new
		
		undated_assignments.each do |assignment|
			if(!assignment.is_disabled(user))
				undisabled_undated_assignments.push assignment
			end
		end
		
		return undisabled_undated_assignments
	end

	# Get the average grade for the course. This will only return
	# the average if there are more than 2 students (privacy
	# reasons), if there is a grade, and if the worth is above 0.
	def average
		if 2 < users.length
			average = 0
			grades  = 0

			users.each do |user|
				grade = self.user_grade(user)
				
				if grade
					average = average + grade
					grades  = grades + 1
				end
			end

			return average / grades
		end
	end

	# Get the maximum grade percentage for this course. This will
	# only return the maximum if there are more than two students
	# in the course (privacy reasons) and the worth is above 0.
	def maximum
		if 2 < users.length
			maximum = 0
			
			users.each do |user|
				grade = self.user_grade(user)
				
				if grade and maximum < grade
					maximum = grade
				end
			end

			return maximum
		end
	end

	# Get the minimum grade percentage for this course. This
	# will only return the minimum if there are more than two
	# students in the course (privacy reasons) and the worth
	# is above 0.
	def minimum
		if 2 < users.length
			minimum = 999
			
			users.each do |user|
				grade = self.user_grade(user)
				
				if grade and grade < minimum
					minimum = grade
				end
			end

			return minimum
		end
	end
end
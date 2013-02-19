#   File: assignment_type.rb
#  Class: AssignmentType
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds information for assignment types.
# Assignment types are groups of assignments such as tests,
# quizzes, or homeworks. They have a have a weighting against
# the class as a whole (generally as a percentage) and serve
# as a useful way to divide the class into gradable sections.
# -----------------------------------------------------------

class AssignmentType < ActiveRecord::Base
	attr_accessible :description
	attr_accessible :name
	attr_accessible :worth
	attr_accessible :course_id
	attr_accessible :drop_lowest
	attr_accessible :disabled

	validates :name, :presence => true
	validates :worth, :numericality => true, :allow_nil => true

	belongs_to :course
	has_many :assignments, :dependent => :destroy
	
	has_many :grades, :through => :assignments
	has_many :assignment_type_flags, :dependent => :destroy

	# Total number of points under a given assignment type
	# @return [decimal] The sum of all assignments' worth.
	def points
		points = 0
		assignments.each do |assignment|
			points += assignment.worth
		end
		return points
	end
	
	# Get assignments for this assignment type sorted by due date.
	#
	# @return [Array<Assignment>] Sorted assignments
	def sorted_assignments
		return self.assignments.order("due_date")
	end
	
	# Gets the user's grade for this assignment type
	#
	# @param user [User] A User who's grade for the AssignmentType will be calculated.
	# @return [int] the user's grade
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
	
		grades = Grade.joins(:assignment).where('assignments.assignment_type_id' => self.id, :user_id => user)

		if drop_lowest
			# If we are dropping the lowest score, we have to calculate the grades individually
			scores = []
	
			# Calculate each score
			grades.each do |g|
				if g.assignment.worth != 0
					scores.push(g.grade / g.assignment.worth)
				end
			end
			
			# Sort and remove lowest score
			scores = scores.sort
			scores.delete_at(0)
		
			# Calculate grade using remainder
			if scores.length != 0
				return scores.sum / scores.length * 100
			end

		else
			# Calculate the grades in bulk
			grade = grades.sum(:grade).to_f
			worth = grades.sum(:worth).to_f

			if worth != 0
				return (grade / worth) * 100
			end

		end
	end
	
	# Gets the percent of assignments the user has completed.
	#
	# @param user [User] User who's completed assignments will be used to determine how much of the AssignmentType is completed.
	# @return [int] The percent of assignments completed.
	def percent_complete(user)
		completedWorth = 0.0
		totalWorth = 0.0
		
		self.assignments.each do |assignment|
			totalWorth += assignment.worth
			
			if assignment.user_grade(user)
				completedWorth += assignment.worth
			end
		end
		
		if totalWorth != 0
			return completedWorth / totalWorth
		end
	end
	

	
	# Determines whether or not the user has disabled this AssignmentType.
	# Check whether or not the assignment type has been disabled
	# by the user. If there is not an assignment type flag, then
	# the assignment type defaults to the current value of the
	# assignment type. This allows users to express a dissent in
	# their view of enabled assignments.
	#
	# @param user [User] User who may or may not have disabled the AssignmentType.
	# @return [boolean] Returns true if the assignment is disabled and false if it is not.
	# ==== Examples
	#
	#   is_disabled(user) => true	
	def is_disabled(user)
		flag = AssignmentTypeFlag.find_by_assignment_type_id_and_user_id(self.id, user.id)
		
		# check for flag
		if flag.blank?
			# use assignment type disabled
			return self.disabled 
		else
			# use flag disabled
			return flag.disabled
		end
	end
	
	# Calculates the average grade accross all students in the assignment type.
	# This will only return the average if there are more than 2 sutdents (privacy
	# reasons), if there is a grade, and if the worth is above 0.
	# @param user [User] User who may or may not have disabled the AssignmentType.
	# @return [decimal] average
	# ==== Examples
	#
	#   average => 86
	def average
		if 2 < course.users.length and 0 < grades.length and 0 < worth
			average = 0
			grades  = 0

			course.users.each do |user|
				grade = self.user_grade(user)
				
				if grade
					average = average + grade
					grades  = grades + 1
				end
			end

			return average / grades
		end
	end

	# Get the maximum grade percentage for this assignment type. This
	# will only return the maximum if there are more than two
	# students in the course (privacy reasons) and the worth is
	# above 0 .
	#
	# @return [decimal] maximum grade.
	def maximum
		if 2 < course.users.length and 0 < worth
			maximum = 0
			
			course.users.each do |user|
				grade = self.user_grade(user)
				
				if grade and maximum < grade
					maximum = grade
				end
			end

			return maximum
		end
	end

	# Get the minimum grade percentage for this assignment type.
	# This will only return the minimum if there are more than
	# two students in the course (privacy reasons) and the
	# worth is above 0.
	#
	# @return [decimal] Minimum grade.
	def minimum
		if 2 < course.users.length and 0 < worth
			minimum = 999
			
			course.users.each do |user|
				grade = self.user_grade(user)
				
				if grade and grade < minimum
					minimum = grade
				end
			end

			return minimum
		end
	end
end
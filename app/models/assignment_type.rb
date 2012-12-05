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
	attr_accessible :description, :name, :worth, :course_id

	validates :name, :presence => true
	validates :worth, :numericality => true, :allow_nil => true

	belongs_to :course
	has_many :assignments, :dependent => :destroy

	# Get assignments for this assignment type sorted by due date.
	def sorted_assignments
		return self.assignments.order("due_date")
	end
	
	# Get the user's (argument) grade for this assignment type
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		self.assignments.each do |assignment|
			grade = assignment.user_grade(user)
			if grade
				totalGrade += grade
				totalWorth += assignment.worth
			end
		end

		if totalWorth != 0
			return  totalGrade.to_f / totalWorth.to_f * 100
		end
	end
	
	def percent_complete(user)
		completedWorth = 0
		totalWorth = 0
		
		self.assignments.each do |assignment|
			totalWorth += assignment.worth
			
			if assignment.user_grade(user)
				completedWorth += assignment.worth
			end
		end
		
		return completedWorth / totalWorth
	end
end
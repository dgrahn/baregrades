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

	# Total number of points under a given assignment type
	def points
		points = 0
		assignments.each do |assignment|
			points += assignment.worth
		end
		return points
	end
	
	# Get assignments for this assignment type sorted by due date.
	def sorted_assignments
		return self.assignments.order("due_date")
	end
	
	# Get the user's (argument) grade for this assignment type
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0

		grades = Grade.joins(:assignment).where('assignments.assignment_type_id' => self.id, :user_id => user)
		grade = grades.sum(:grade).to_f
		worth = grades.sum(:worth).to_f

		if worth != 0
			return (grade / worth) * 100
		end
	end
	
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
end
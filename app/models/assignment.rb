#   File: assignment.rb
#  Class: Assignment
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class is the model for assignments. It accesses and 
# manipulates the data to give grades, percentages, and
# averages.
# -----------------------------------------------------------

class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :assignment_type_id, :due_date, :disabled

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true
	validates_length_of :description, :maximum => 144
	
	belongs_to :assignment_type
	
	has_many :grades, :dependent => :destroy
	has_many :assignment_flags, :dependent => :destroy
	
	default_scope order("due_date ASC")

	# Get the current users grade for the assignment (points)
	#
	# @param user [User] User whose grade will be retrieved.
	# @return [decimal] Grade.
	def user_grade(user)
		
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade
			return grade.grade
		end
	end
	
	# Get the current users grade for the assignment
	# @param user [User] User whose grade will be retrieved.
	# @return [Grade] Grade.
	def user_grade_class(user)
		
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade.blank?
			grade = Grade.new
		end
		
		return grade
	end
	
	# Get the current users percentage for the assignment.
	# @param user [User] User whose grade will be retrieved.
	# @return [Float] Grade.
	def user_percentage(user)
		worth 		= self.worth
		grade 		= self.user_grade(user)
		
		if !grade.blank? && !worth.blank? && worth != 0
			percent 	= (grade.to_f / worth.to_f) * 100
			return percent
		end
	end
	
	# Get the course for this assignment. This is necessary
	# because belongs to cannot have a through.
	# @return [Course] The course.
	def course
		return self.assignment_type.course
	end

	# Get the average grade for this assignment. This will only
	# return the average if there are more than 2 students in
	# the course (for privacy reasons).
	# @return [float] The average.
	def average
		if 2 < course.users.length and 0 < grades.length and 0 < worth
			average = (grades.sum(:grade) / grades.length);
			average = (average.to_f / worth) * 100;
			return average
		end
	end

	# Get the maximum grade percentage for this assignment.
	# This will only return the maximum if there are more than
	# two students in the course (privacy reasons).
	# @return [float] maximum
	def maximum
		if course.users.length > 2 and worth > 0
			return (grades.maximum(:grade).to_f / worth) * 100
		end
	end

	# Get the minimum grade percentage for this assignment.
	# This will only return the minimum if there are more than
	# two students in the course (privacy reasons).
	# @return [float] minimum
	def minimum
		if course.users.length > 2 and worth > 0
			return (grades.minimum(:grade).to_f / worth) * 100
		end
	end
	
	# Checks if the assignment is disabled for the given user.
	# @param user [User]
	# @return [boolean] Assignment is disabled for this user or not.
	def is_disabled(user)
		flag = AssignmentFlag.find_by_assignment_id_and_user_id(self.id, user.id)
		if(flag.blank?)
			return self.disabled
		else
			return flag.disabled
		end
	end
	
end
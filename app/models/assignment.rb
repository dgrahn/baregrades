# The program creates a way for students to manage and post
# their grades from various classes. Students can collaborate
# on classes and view course averages.
#
# Author:: Dan Grahn, Matt Brooker, Justin Engel
#
# This class is the model for assignments. It accesses and 
# manipulates the data to give grades, percentages, and
# averages.

class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :assignment_type_id, :due_date

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true
	validates_length_of :description, :maximum => 144
	
	belongs_to :assignment_type
	
	has_many :grades
	

	# Get the current users grade for the assignment (points)
	def user_grade(user)
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade
			return grade.grade
		end
	end
	
	# Get the current users percentage for the assignment.
	def user_percentage(user)
		worth 		= self.worth
		grade 		= self.user_grade(user)
		
		if !grade.blank? && !worth.blank?
			percent 	= (grade.to_f / worth.to_f) * 100
			return percent
		end
	end
	
	# Get the course for this assignment. This is necessary
	# because belongs to cannot have a through.
	def course
		return self.assignment_type.course
	end

	# Get the average grade for this assignment. This will only
	# return the average if there are more than 2 students in
	# the course (for privacy reasons).
	def average
		if course.users.length > 2
			average = (grades.sum(:grade) / grades.length);
			average = (average / worth) * 100;
			return average
		end
	end
end
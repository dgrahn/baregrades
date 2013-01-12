#   File: grade.rb
#  Class: Grade
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# The class holds the information for the gradescale for a
# specific course.
# -----------------------------------------------------------

class GradeScale < ActiveRecord::Base
	after_initialize :default_values
	attr_accessible :a, :a_minus, :a_plus, :b, :b_minus, :b_plus, :c, :c_minus, :c_plus, :course_id, :d, :d_minus, :d_plus, :f, :f_minus, :f_plus
  
	belongs_to :course

	def default_values
		self.b_plus = 87
		self.c_plus = 77
		self.d_plus = 67

		self.a = 93
		self.b = 83
		self.c = 73
		self.d = 63

		self.a_minus = 90
		self.b_minus = 80
		self.c_minus = 70
		self.d_minus = 60
	end
end
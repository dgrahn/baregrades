#   File: grade.rb
#  Class: Grade
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds the grade for a single assignment type for
# a single user.
# -----------------------------------------------------------

class Grade < ActiveRecord::Base
	attr_accessible :grade
	
	has_one :assignment
	has_one :user
	
	validates :grade, :numericality => true

	belongs_to :assignment
	belongs_to :user
end
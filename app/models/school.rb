#   File: school.rb
#  Class: School
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds a school.
# -----------------------------------------------------------
class School < ActiveRecord::Base
	attr_accessible :name
	
	validates :name, :uniqueness => true
end
#   File: professor.rb
#  Class: Professor
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds a professor.
# -----------------------------------------------------------
class Professor < ActiveRecord::Base
	attr_accessible :name
	
	validates :name, :uniqueness => true
end